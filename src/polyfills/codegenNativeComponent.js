// Polyfill for codegenNativeComponent
// This is a simplified version that just returns a component factory function

export default function codegenNativeComponent(name, options = {}) {
  return (props) => {
    console.warn(`Using polyfilled ${name} component`);
    return null;
  };
}
