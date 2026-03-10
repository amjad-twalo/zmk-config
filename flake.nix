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
      # Use same system as reference
      system = "x86_64-apple-darwin"; # Set to user's mac system
      pkgs = nixpkgs.legacyPackages.${system};

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
        let
          builders = zmk-nix.legacyPackages.${system};
        in
        builders.buildKeyboard {
          inherit
            name
            board
            shield
            extraCmakeFlags
            ;
          src = pkgs.lib.cleanSource ./.;
          config = "config";
          # This hash might need update later if west.yml changes
          zephyrDepsHash = "sha256-otsUf6aEeOmAUOV76YNXaYANAIhDWX+mm4ye8GoJ7WM=";
        };
    in
    {
      packages.${system} =
        let
          firmwarePackages = pkgs.lib.mapAttrs mkKeyboardFirmware keyboards;
        in
        firmwarePackages // {
          default = firmwarePackages.photon_dongle;
        };

      devShells.${system}.default = zmk-nix.devShells.${system}.default;
    };
}
