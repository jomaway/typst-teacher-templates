#!/usr/bin/env python3
import os
import sys
import shutil
import argparse
import tempfile
from pathlib import Path

# List of all files that get packaged
files = [
    "typst.toml",
    "README.md",
    "LICENSE",
]

# Local package directories per platform
if sys.platform.startswith("linux"):
    data_dir = os.environ.get("XDG_DATA_HOME", Path.home() / ".local" / "share")
elif sys.platform == "darwin":
    data_dir = Path.home() / "Library" / "Application Support"
else:
    data_dir = Path(os.environ.get("APPDATA"))

def parse_arguments():
    parser = argparse.ArgumentParser(description="Package relevant files into a directory named '<PACKAGE>/<version>'")
    parser.add_argument("package", help="Package name")
    parser.add_argument("target", help="Target path or @local/@preview")
    return parser.parse_args()

def main():
    args = parse_arguments()

    pkg_prefix = args.package
    source = Path(__file__).resolve().parent.parent / pkg_prefix
    target = args.target

    print(f"Source file {source}")

    for file in files:
        if not (source / file).exists():
            print(f"File {file} is missing.")
            exit(-1)

    # Extract the version of the typst.toml using awk
    with open(source / "typst.toml") as f:
        for line in f:
            if line.startswith("version"):
                version = line.split("=")[-1].strip().strip('"')
                break
            elif line.startswith("exclude"):
                exclude = line.split("=")[-1].strip().strip('"')
            else:
                exclude = []

    print("Version:", version)
    print("Exclude:", exclude)

    if target == "@local" or target == "install":
        target = data_dir / "typst" / "packages" / "local"
        print("Install dir:", target)
    elif target == "@preview":
        target = data_dir / "typst" / "packages" / "preview"
        print("Install dir:", target)
    else:
        target = Path(target)
    
    with tempfile.TemporaryDirectory() as tmp_dir:

        for file_path in source.glob("**/*"):
            if file_path.is_file() and file_path.name not in exclude:
                rel_path = file_path.relative_to(source)
                dest_path = Path(tmp_dir) / rel_path
                dest_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(file_path, dest_path)
        


        target = target / pkg_prefix / version
        print("Packaged to:", target)

        if target.exists():
            print("Overwriting existing version.")
            shutil.rmtree(target)
        # target.mkdir(parents=True, exist_ok=True)
        shutil.copytree(Path(tmp_dir), target)

if __name__ == "__main__":
    main()
