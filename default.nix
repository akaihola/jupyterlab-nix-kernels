# Usage:
#
# $ nix-shell all-pythons.nix
#
# Installing kernels for nix-shell environments which use a virtualenv:
#
# $ cd ~/myproject
# $ nix-shell default.nix
# $ pip install ipykernel ipython_genutils
# $ ~/prg/jupyterlab/add_kernel.py

{ pkgs ? import <nixpkgs> {}, cmd ? "jupyter lab -y" }:
# { pkgs ? import <nixpkgs> {}, cmd ? "python -Xfrozen_modules=off -m jupyterlab -y" }:

(
  let
    rootdir = builtins.toString ./.;
    project = builtins.baseNameOf ./.;
    home = builtins.getEnv "HOME";
    venv = "${home}/.virtualenvs/" + project;
  in
    pkgs.buildFHSUserEnv {
      name = project;
      targetPkgs = pkgs: (with pkgs; [
        chromium
        pandoc
        (python311.withPackages (ps: with ps; with python311Packages; [
          #    ipykernel
          #    jupyterlab
          #    nbconvert
          #    pip
        ]))
        (python310.withPackages (ps: with ps; with python310Packages; [
          ipykernel
          jupyterlab
          nbconvert
          nodejs
          pip
        ]))
        (python39.withPackages (ps: with ps; with python39Packages; [
          #   ipykernel
          #   jupyterlab
          #   pip
        ]))
        (python38.withPackages (ps: with ps; with python38Packages; [
          #   ipykernel
          #   jupyterlab
          #   pip
        ]))
        (python37.withPackages (ps: with ps; with python37Packages; [
          #   ipykernel
          #   jupyterlab
          #   pip
        ]))
        (python27.withPackages (ps: with ps; with python27Packages; [
          #   ipykernel
          #   jupyterlab
          #   pip
        ]))
      ]);

      runScript = "
      cd ${rootdir}
      [[ -d ${venv} ]] || (
        python3.11 -m venv ${venv}
        ${venv}/bin/pip install dataframe-image
      )
      . ${venv}/bin/activate
      ${cmd}
      ";
    }
).env
