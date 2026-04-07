#!/bin/bash

# 1. Resolve the absolute path of the directory containing this bash script (Project Root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# 2. Inject the project root into PYTHONPATH, then execute uv run pointing to 'src/'
env PYTHONPATH="$SCRIPT_DIR" uv run --with pycryptodome \
    --with-requirements "$SCRIPT_DIR/src/requirements.txt" \
    "$SCRIPT_DIR/src/vcdNSXMigrator.py" "$@"