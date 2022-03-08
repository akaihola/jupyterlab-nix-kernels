# Usage:
#
# $ nix-shell all-pythons.nix
#
# Installing kernels for virtualenvs:
#
# $ ~/.virtualenvs/myvenv/bin/activate
# $ pip install ipykernel
# $ VENVNAME=${VIRTUAL_ENV##*/}
# $ KRNLPTH=~/.local/share/jupyter/kernels/$VENVNAME/kernel.json
# $ python -m ipykernel install \
#     --user \
#     --name $VENVNAME \
#     --env VIRTUAL_ENV $VIRTUAL_ENV \
#     --env PATH $VIRTUAL_ENV/bin:$PATH
# $ jq '.argv |= ["steam-run"] + .' $KRNLPTH | sponge $KRNLPTH
#

# { pkgs ? import <nixpkgs> {}, pythonPackages ? pkgs.python39Packages }:
# (
#   pkgs.buildFHSUserEnv {
#     name = "jupyter";
#     targetPkgs = pkgs: (with pkgs; [
#       (python39.withPackages (ps: with ps; [
#         python
#         ipykernel
#         jupyterlab
#         pip
#       ]))
#       (python310.withPackages (ps: with ps; [
#         python
#       ]))
#     ]);

#     # Automatically run jupyter when entering the shell.
#     runScript = "
#       cd ${builtins.toString ./.}
#       jupyter lab
#     ";
#   }
# ).env

{ pkgs ? import <nixpkgs> {}, cmd ? "jupyter lab -y" }:

(
  let
    rootdir = builtins.toString ./.;
    project = builtins.baseNameOf ./.;
    home = builtins.getEnv "HOME";
  in
    pkgs.buildFHSUserEnv {
      name = project;
      targetPkgs = pkgs: (with pkgs; [
        # Defines a python + set of packages.
        (python39.withPackages (ps: with ps; with python39Packages; [
          ipykernel
          jupyterlab
          pip
        ]))
        (python38.withPackages (ps: with ps; with python38Packages; [
          #   ipykernel
          #   jupyterlab
          #   pip
        ]))
        (python310.withPackages (ps: with ps; with python310Packages; [
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
        cd ${builtins.toString ./.}
        ${cmd}
      ";
    }
).env
