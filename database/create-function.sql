-- Create function to execute SQL
CREATE OR REPLACE FUNCTION run_sql(sql_query text)
RETURNS void AS $$
BEGIN
  EXECUTE sql_query;
END;
$$ LANGUAGE plpgsql;
