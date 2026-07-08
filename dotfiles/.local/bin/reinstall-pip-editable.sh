#!/bin/bash

if [ -z "$VIRTUAL_ENV" ]; then
    echo "Error: activate the venv first (source /path/to/venv/bin/activate)"
    exit 1
fi

echo "=== Editable packages detected ==="
paths=()
while IFS= read -r line; do
    path="$(echo "$line" | awk '{print $NF}')"
    if [ -d "$path" ]; then
        echo "  $path"
        paths+=("$path")
    else
        echo "  SKIP (not found): $path"
    fi
done < <(pip list --editable --format=columns 2>/dev/null | tail -n +3 | grep -v '^$')

if [ ${#paths[@]} -eq 0 ]; then
    echo "No editable packages found."
    exit 0
fi

echo ""
echo "=== Reinstalling ${#paths[@]} packages ==="
if command -v uv &> /dev/null; then
    echo "Using uv"
    cmd="uv pip install"
    extra_args="--config-settings editable_mode=compat"
else
    echo "Using pip"
    cmd="pip install"
    extra_args=""
fi
for p in "${paths[@]}"; do
    cd "$p" && eval "$cmd -e . $extra_args"
done
