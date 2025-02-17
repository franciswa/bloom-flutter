-- Add composite indexes for common query patterns
CREATE INDEX IF NOT EXISTS messages_match_created_idx ON messages(match_id, created_at DESC);

-- Add composite index for archived messages
CREATE INDEX IF NOT EXISTS archived_messages_match_created_idx ON archived_messages(match_id, created_at DESC);

-- Add batch size parameter to cleanup function for better performance
CREATE OR REPLACE FUNCTION cleanup_old_archived_messages(batch_size INT DEFAULT 1000)
RETURNS void AS $$
DECLARE
    deleted INT;
BEGIN
    LOOP
        -- Delete in batches to prevent long locks
        WITH batch AS (
            SELECT id 
            FROM archived_messages
            WHERE archived_at < NOW() - INTERVAL '1 year'
            LIMIT batch_size
            FOR UPDATE SKIP LOCKED
        )
        DELETE FROM archived_messages a
        USING batch b
        WHERE a.id = b.id;

        GET DIAGNOSTICS deleted = ROW_COUNT;
        
        EXIT WHEN deleted < batch_size;
        -- Small pause between batches to reduce system load
        PERFORM pg_sleep(0.1);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Add function to archive old messages in batches
CREATE OR REPLACE FUNCTION archive_old_messages(
    age_threshold INTERVAL DEFAULT INTERVAL '6 months',
    batch_size INT DEFAULT 1000
)
RETURNS void AS $$
DECLARE
    archived INT;
BEGIN
    LOOP
        WITH batch AS (
            SELECT id
            FROM messages
            WHERE created_at < NOW() - age_threshold
            LIMIT batch_size
            FOR UPDATE SKIP LOCKED
        ),
        to_archive AS (
            DELETE FROM messages m
            USING batch b
            WHERE m.id = b.id
            RETURNING 
                m.id,
                m.match_id,
                m.sender_id,
                m.content,
                m.is_system_message,
                m.created_at,
                m.updated_at
        )
        INSERT INTO archived_messages (
            id,
            match_id,
            sender_id,
            content,
            is_system_message,
            created_at,
            updated_at
        )
        SELECT * FROM to_archive;

        GET DIAGNOSTICS archived = ROW_COUNT;
        
        EXIT WHEN archived < batch_size;
        -- Small pause between batches
        PERFORM pg_sleep(0.1);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Update cleanup job to use batching
SELECT cron.schedule(
    'cleanup-archived-messages',
    '0 0 1 * *',  -- At midnight on the first day of every month
    $$
    SELECT cleanup_old_archived_messages(1000);
    SELECT archive_old_messages(INTERVAL '6 months', 1000);
    $$
);
