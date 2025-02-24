/// <reference types="jest" />

declare global {
  const jest: typeof import('@jest/globals')['jest'];
  namespace jest {
    interface Mock<T = any, Y extends any[] = any> {
      (...args: Y): T;
      mockClear(): void;
      mockReset(): void;
      mockRestore(): void;
      mockImplementation(fn: (...args: Y) => T): this;
      mockImplementationOnce(fn: (...args: Y) => T): this;
      mockReturnThis(): this;
      mockReturnValue(value: T): this;
      mockReturnValueOnce(value: T): this;
      mockResolvedValue(value: Awaited<T>): this;
      mockResolvedValueOnce(value: Awaited<T>): this;
      mockRejectedValue(value: any): this;
      mockRejectedValueOnce(value: any): this;
      getMockName(): string;
      mock: {
        calls: Y[];
        instances: T[];
        contexts: any[];
        results: Array<{ type: 'return' | 'throw'; value: any }>;
        lastCall: Y;
      };
    }
  }
}

declare module '@testing-library/react-hooks' {
  export interface RenderHookResult<R, P> {
    result: {
      current: R;
      error?: Error;
    };
    waitForNextUpdate: (options?: { timeout?: number }) => Promise<void>;
    waitForValueToChange: (selector: () => any, options?: { timeout?: number }) => Promise<void>;
    rerender: (props?: P) => void;
    unmount: () => void;
  }

  export function renderHook<TProps, TResult>(
    callback: (props: TProps) => TResult,
    options?: {
      initialProps?: TProps;
      wrapper?: React.ComponentType<any>;
    }
  ): RenderHookResult<TResult, TProps>;
}

declare module '@testing-library/jest-native/extend-expect' {
  global {
    namespace jest {
      interface Matchers<R> {
        toBeDisabled(): R;
        toContainElement(element: React.ReactElement | null): R;
        toBeEmpty(): R;
        toHaveProp(prop: string, value?: any): R;
        toHaveTextContent(text: string | RegExp): R;
        toBeEnabled(): R;
        toHaveStyle(style: object | object[]): R;
      }
    }
  }
}

export {};
