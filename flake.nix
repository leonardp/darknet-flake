{
  description = "darknet flake";

  inputs = {
    #nixpkgs      = { url = "github:nixos/nixpkgs/nixos-unstable"; };
  };

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      opencvOverride = { enableGtk3 = true; };
    in {

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          darknet = pkgs.callPackage ./nix/darknet.nix {};
          pydnet = pkgs.callPackage ./nix/pydnet.nix { darknet=self.packages.${system}.darknet; };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.darknet);

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              (python3.withPackages(ps: with ps; [
                #ipython
                jupyter
                (opencv4.override opencvOverride) # gtk needed for .imshow etc...
                matplotlib
                self.packages.${system}.pydnet
              ]))

              (self.packages.${system}.darknet.override { opencv=(opencv.override opencvOverride); })
            ];

            shellHook = ''
              #cd demo-yolov4-tiny/
              jupyter notebook
            '';
          };
      });

      apps = forAllSystems (system: {
        default = { type = "app";
          program = "${self.packages.${system}.darknet}/bin/darknet"; };
      });
  };
}
