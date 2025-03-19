import os
import subprocess
import tempfile

BLACKLIST = [
    ".ssh/",
    ".tmuxp/",
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


tmp_dir = clone()
targets = compare(tmp_dir)
# pprint(targets)

build(tmp_dir, targets)
cleanup(tmp_dir)
