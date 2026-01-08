{
  description = "Development environment";

  inputs = {
    nixpkgs.url = "github:hilaolu/nixpkgs/pipe-operator";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pythonPackages = p: with p; [
          pkgs.python313Packages.ipython
          pkgs.python313Packages.ipykernel
          pkgs.python313Packages.matplotlib
          pkgs.python313Packages.pixcat
          pkgs.python313Packages.imgcat
          pkgs.python313Packages.numpy
          pkgs.python313Packages.pandas
          pkgs.python313Packages.pipe-operator
          pkgs.python313Packages.bioblend
          pkgs.python313Packages.redun
          pkgs.python313Packages.python-dotenv
          pkgs.python313Packages.trafilatura
        ];
        pythonEnv = pkgs.python313.withPackages pythonPackages;
      in {
        # set environment variable for Zed to detect the python path
        MY_PYTHON_PATH = "${pythonEnv}/bin/python";
        devShells.default = pkgs.mkShell {
          packages = [
            pythonEnv
            pkgs.basedpyright
            pkgs.marksman
            pkgs.ruff
            pkgs.pyright
            pkgs.bc
          ];

        };
      });
}
