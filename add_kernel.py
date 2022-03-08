#!/usr/bin/env python

import json
import os
import sys
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from pathlib import Path

from ipykernel.kernelspec import install


def main():
    parser = ArgumentParser(formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument(
        "--nix-shell",
        default=str(Path("default.nix").absolute()),
        help="Path to the nix-shell file",
    )
    parser.add_argument(
        "--venv",
        default=sys.prefix,
        help=f"Path to the virtualenv",
    )
    opts = parser.parse_args()
    if not Path(opts.nix_shell).is_file():
        raise RuntimeError(f"{opts.nix_shell} doesn't exist")
    venv_name = Path(opts.venv).name
    install(
        user=True,
        kernel_name=venv_name,
        env={
            "VIRTUAL_ENV": opts.venv,
            "PATH": f"{opts.venv}/bin:{os.environ['PATH']}",
        },
    )
    kernel_path = Path(
        f"~/.local/share/jupyter/kernels/{venv_name}/kernel.json"
    ).expanduser()
    with kernel_path.open() as kernel_file:
        kernel = json.load(kernel_file)
    cmdline = " ".join(kernel["argv"])
    kernel["argv"] = [
        "nix-shell",
        opts.nix_shell,
        "--argstr",
        "cmd",
        f"bash -c '{cmdline}'",
    ]
    kernel_path.write_text(json.dumps(kernel, indent=4))


if __name__ == "__main__":
    main()
