{ pkgs }: {
    deps = [
        pkgs.nodejs-20_x
        pkgs.nodePackages.typescript-language-server
        pkgs.nodePackages.yarn
        pkgs.replitPackages.jest
        pkgs.pkg-config
        pkgs.libpng
        pkgs.libjpeg
        pkgs.libuuid
        pkgs.python3
        pkgs.watchman
    ];
    env = {
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.libuuid
        ];
    };
}
