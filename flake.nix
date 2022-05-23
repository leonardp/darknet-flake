{
  description = "darknet flake";

  inputs = {
    #nixpkgs      = { url = "github:nixos/nixpkgs/nixos-unstable"; };
  };

  outputs = { self, nixpkgs, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      #
      ## (un)comment the flags you want here
      #

      darknetOverride = {
        #cudaSupport = true;
        #cudnnSupport = true;
      };
      opencvOverride = {
        enableGtk3 = true;
      };
    in {

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          darknet = pkgs.callPackage ./nix/darknet.nix darknetOverride;
          pydnet = pkgs.callPackage ./nix/pydnet.nix { darknet = self.packages.${system}.darknet; };
      });

      defaultPackage = forAllSystems (system: self.packages.${system}.darknet);

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              (python3.withPackages(ps: with ps; [
                self.packages.${system}.pydnet
                (opencv4.override opencvOverride)
              ]))
              cowsay
              fortune
              (self.packages.${system}.darknet.override darknetOverride
                // { opencv = (opencv.override opencvOverride); })
            ];

            shellHook = "cowsay Oh Hai!"; # "fortune | cowsay";
          };
      });

      apps = forAllSystems (system: {
        default = { type = "app";
          program = "${self.packages.${system}.darknet}/bin/darknet"; };
      });

      templates = {
        demo-yolov4-tiny = {
          path = ./demo-yolov4-tiny;
          description = "Jupyter notebook demonstrating inference on an image using yolov4-tiny.";
        };

        yolo-custom = {
          path = ./yolo-custom;
          description = "template for training your own models";
        };
      };

      defaultTemplate = self.templates.demo-yolov4-tiny;
  };
}
