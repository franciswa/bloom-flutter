import { renderHook, act } from '@testing-library/react-hooks';
import { useNotifications } from '../useNotifications';
import { supabase } from '../../lib/supabaseClient';
import * as Notifications from 'expo-notifications';
import { getDeviceId } from '../../utils/deviceId';

// Mock dependencies
jest.mock('../../lib/supabaseClient', () => ({
  supabase: {
    auth: {
      getUser: jest.fn(),
    },
    select: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
    insert: jest.fn(),
    channel: jest.fn(() => ({
      on: jest.fn().mockReturnThis(),
      subscribe: jest.fn(),
    })),
  },
}));

const mockPlatform = {
  OS: 'ios',
  select: jest.fn(),
};

jest.mock('react-native/Libraries/Utilities/Platform', () => mockPlatform);

jest.mock('expo-notifications', () => ({
  getPermissionsAsync: jest.fn().mockResolvedValue({ status: 'granted' }),
  requestPermissionsAsync: jest.fn().mockResolvedValue({ status: 'granted' }),
  getExpoPushTokenAsync: jest.fn().mockResolvedValue({ data: 'test-push-token' }),
  setNotificationHandler: jest.fn(),
  addNotificationReceivedListener: jest.fn(() => ({
    remove: jest.fn(),
  })),
}));

jest.mock('../../utils/deviceId', () => ({
  getDeviceId: jest.fn(),
}));

describe('useNotifications', () => {
  const mockUser = { id: 'test-user-id' };
  const mockNotifications = [
    {
      id: '1',
      user_id: mockUser.id,
      type: 'match',
      title: 'New Match',
      message: 'You have a new match!',
      read: false,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    },
  ];

  beforeEach(() => {
    jest.clearAllMocks();
    process.env.EXPO_PROJECT_ID = 'test-project-id';
    mockPlatform.OS = 'ios';
    (supabase.auth.getUser as jest.Mock).mockResolvedValue({ user: mockUser });
    (supabase.select as jest.Mock).mockResolvedValue(mockNotifications);
    (getDeviceId as jest.Mock).mockResolvedValue('test-device-id');
    (Notifications.getPermissionsAsync as jest.Mock).mockResolvedValue({ status: 'granted' });
    (Notifications.getExpoPushTokenAsync as jest.Mock).mockResolvedValue({ data: 'test-push-token' });
  });

  it('should fetch notifications on mount', async () => {
    const { result, waitForNextUpdate } = renderHook(() => useNotifications());
    
    expect(result.current.loading).toBe(true);
    await waitForNextUpdate();
    
    expect(result.current.loading).toBe(false);
    expect(result.current.notifications).toEqual(mockNotifications);
    expect(result.current.error).toBeNull();
  });

  it('should mark notification as read', async () => {
    const { result, waitForNextUpdate } = renderHook(() => useNotifications());
    await waitForNextUpdate();

    await act(async () => {
      await result.current.markAsRead('1');
    });

    expect(supabase.update).toHaveBeenCalledWith(
      'notifications',
      { id: '1' },
      { read: true },
      'Notifications.MarkAsRead'
    );
    expect(result.current.notifications[0].read).toBe(true);
  });

  it('should mark all notifications as read', async () => {
    const { result, waitForNextUpdate } = renderHook(() => useNotifications());
    await waitForNextUpdate();

    await act(async () => {
      await result.current.markAllAsRead();
    });

    expect(supabase.update).toHaveBeenCalledWith(
      'notifications',
      { user_id: mockUser.id, read: false },
      { read: true },
      'Notifications.MarkAllAsRead'
    );
    expect(result.current.notifications.every(n => n.read)).toBe(true);
  });

  it('should delete notification', async () => {
    const { result, waitForNextUpdate } = renderHook(() => useNotifications());
    await waitForNextUpdate();

    await act(async () => {
      await result.current.deleteNotification('1');
    });

    expect(supabase.delete).toHaveBeenCalledWith(
      'notifications',
      { id: '1' },
      'Notifications.Delete'
    );
    expect(result.current.notifications).toHaveLength(0);
  });

  it('should return false for web platform', async () => {
    mockPlatform.OS = 'web';
    const { result } = renderHook(() => useNotifications());
    const success = await result.current.requestPermissions();
    expect(success).toBe(false);
    expect(Notifications.getPermissionsAsync).not.toHaveBeenCalled();
  });

  it('should request notification permissions and register push token', async () => {
    mockPlatform.OS = 'ios';
    const { result, waitForNextUpdate } = renderHook(() => useNotifications());
    await waitForNextUpdate();

    await act(async () => {
      const success = await result.current.requestPermissions();
      expect(success).toBe(true);
    });

    expect(Notifications.getPermissionsAsync).toHaveBeenCalled();
    expect(Notifications.getExpoPushTokenAsync).toHaveBeenCalled();
    expect(supabase.update).toHaveBeenCalledWith(
      'push_tokens',
      { device_id: 'test-device-id', is_valid: true },
      { is_valid: false },
      'PushToken.Invalidate'
    );
    expect(supabase.insert).toHaveBeenCalledWith(
      'push_tokens',
      expect.objectContaining({
        user_id: mockUser.id,
        token: 'test-push-token',
        device_id: 'test-device-id',
        is_valid: true,
      }),
      'PushToken.Register'
    );
  });

  it('should handle errors gracefully', async () => {
    const error = new Error('Failed to fetch');
    (supabase.select as jest.Mock).mockRejectedValueOnce(error);
    (supabase.auth.getUser as jest.Mock).mockResolvedValue({ user: mockUser });

    const { result, waitForNextUpdate } = renderHook(() => useNotifications());
    
    expect(result.current.loading).toBe(true);
    await waitForNextUpdate();

    expect(result.current.error).toBe(error.message);
    expect(result.current.notifications).toEqual([]);
    expect(result.current.loading).toBe(false);
  });
});
