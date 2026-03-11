{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    zmk-nix = {
      url = "github:lilyinstarlight/zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, zmk-nix, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          builders = zmk-nix.legacyPackages.${system};

          # Boards and Shields configuration
          keyboards = {
            photon = {
              board = "photon//zmk";
            };
            photon_peripheral = {
              board = "photon//zmk";
              extraCmakeFlags = [ "-DEXTRA_CONF_FILE=${./config/boards/cannonkeys/photon/photon_peripheral.conf}" ];
            };
            photon_dongle = {
              board = "xiao_ble//zmk";
              shield = "photon_dongle rgbled_adapter";
              extraCmakeFlags = [ 
                "-DCONFIG_ZMK_STUDIO=y"
                "-DSNIPPET=studio-rpc-usb-uart" 
              ];
            };
            dongle_reset = {
              board = "xiao_ble//zmk";
              shield = "settings_reset";
            };
          };

          mkKeyboardFirmware =
            name:
            {
              board,
              shield ? null,
              extraCmakeFlags ? [ ],
              ...
            }:
            builders.buildKeyboard {
              inherit
                name
                board
                shield
                extraCmakeFlags
                ;
              # NOTE: ZMK Studio requires 'protoc' and its Python bindings
              nativeBuildInputs = [
                pkgs.protobuf
                (pkgs.python3.withPackages (ps: with ps; [
                  protobuf
                  grpcio-tools
                ]))
              ];
              src = pkgs.lib.cleanSource ./.;
              config = "config";
              # This hash depends on the contents of config/west.yml
              zephyrDepsHash = "sha256-0+UOYhtuhQWexrIqj2PsKSHtjQug9I4JnXi6kuKXIVo=";
            };

          firmwarePackages = pkgs.lib.mapAttrs mkKeyboardFirmware keyboards;

          # Combined package to build all firmwares at once with descriptive names
          all = pkgs.runCommand "all-firmwares" { } ''
            mkdir -p $out
            ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: pkg: "cp ${pkg}/zmk.uf2 $out/${name}.uf2") firmwarePackages)}
          '';
        in
        firmwarePackages // {
          inherit all;
          default = all;
        });

      devShells = forAllSystems (system: {
        default = zmk-nix.devShells.${system}.default;
      });
    };
}
