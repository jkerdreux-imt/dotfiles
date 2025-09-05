#!/usr/bin/env python3

import os
import subprocess
import tempfile

BLACKLIST = [
    ".ssh/",
    ".gitconfig",
    ".tmuxp/",
    ".config/broot",
    ".config/yazi",
    ".config/neomutt/",
    ".local/bin/chezmoi-commit",
    ".local/bin/chezmoi-clone",
    ".local/bin/chezmoi-token",
    ".local/bin/chezmoi-filter",
    ".config/helix/languages.toml",
]

DEST = os.path.join(os.environ["PWD"], "dotfiles")


def clone():
    tmp_dir = tempfile.mkdtemp()
    tmp_dir = os.path.join(tmp_dir, "")
    cmd = 'chezmoi archive|tar xvfz - -C "%s" ' % tmp_dir
    subprocess.run(
        cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    return tmp_dir


def cleanup(path):
    pass
    os.system("rm -rf %s" % path)


def black_listed(path):
    for b in BLACKLIST:
        if path.startswith(b):
            return True
    return False


def compare(path):
    result = []
    for root, sub, files in os.walk(path):
        root = root.replace(path, "")
        for s in sub:
            target = os.path.join(root, s, "")
            if target in BLACKLIST:
                # print("Skipping blacklisted directory %s" % target)
                continue
            result.append(target)

        for f in files:
            target = os.path.join(root, f)
            if black_listed(target):
                # print("Skipping blacklisted file %s" % target)
                continue
            result.append(target)
    return result


def build(tmp_dir, targets):
    for t in targets:
        if t.endswith("/"):
            os.system(f'mkdir -p "{os.path.join(DEST, t)}"')
        else:
            src = os.path.join(tmp_dir, t)
            dest = os.path.join(DEST, t)
            os.system(f'cp "{src}" "{dest}"')


def check(targets):
    for root, sub, files in os.walk(DEST):
        root = root.replace(DEST, "")
        root = root[1:] if root.startswith("/") else root
        for s in sub:
            target = os.path.join(root, s, "")
            if target not in targets and not black_listed(target):
                print(f"{target} Not found")

        for f in files:
            target = os.path.join(root, f)
            if target not in targets and not black_listed(target):
                print(f"{target} Not found")


# Clone chezmoi config in a tmp folder
tmp_dir = clone()
# List all files and directories in the tmp folder that are not blacklisted
targets = compare(tmp_dir)
# Populate the DEST folder with the files and directories
build(tmp_dir, targets)
# Ditch files and directories that are not in the tmp folder
check(targets)

# Remove the tmp folder
cleanup(tmp_dir)
