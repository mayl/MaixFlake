{
  description = "A flake with tools for working on the Maix series of K210 boards";

  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        kflash-gui-appimage = pkgs.fetchurl {
          url = "https://github.com/sipeed/kflash_gui/releases/download/v1.8.1/kflash_gui_v1.8.1_linux_glibc2.35.AppImage";
          sha256 = "06rk2al3i48m0gxjhm9yc8nq3pyifmzr4swvkbv82w6l8dlcmhwq";
        };
      in
      {
        packages = rec {
          hello = pkgs.hello;
          default = hello;
        };
        apps = rec {
          hello = flake-utils.lib.mkApp { drv = self.packages.${system}.hello; };
          kflash-gui = flake-utils.lib.mkApp {
            drv = pkgs.writeShellScriptBin "kflash-gui" ''
              QT_QPA_PLATFORM=wayland exec ${pkgs.appimage-run}/bin/appimage-run ${kflash-gui-appimage}
            '';
          };
          default = hello;
        };
      }
    );
}
