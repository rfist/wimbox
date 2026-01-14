#!/bin/bash

# Define the source of truth for environment variables (script can run from anywhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
GLOBAL_ENV_PATH="$ROOT_DIR/env/global.env"
STACKS_DIR="$ROOT_DIR/stacks"

echo "Starting environment linkage..."

# Check if global env exists
if [ ! -f "$GLOBAL_ENV_PATH" ]; then
    echo "Error: $GLOBAL_ENV_PATH not found!"
    exit 1
fi

# Find all subdirectories in stacks/
find "$STACKS_DIR" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r stack_dir; do
    echo "Processing $stack_dir..."
    
    # Define the target .env link path
    TARGET_ENV="$stack_dir/.env"
    if command -v realpath >/dev/null 2>&1; then
        LINK_TARGET="$(realpath --relative-to="$stack_dir" "$GLOBAL_ENV_PATH")"
    else
        LINK_TARGET="$GLOBAL_ENV_PATH"
    fi
    
    # Check if .env already exists
    if [ -e "$TARGET_ENV" ]; then
        if [ -L "$TARGET_ENV" ]; then
            CURRENT_TARGET="$(readlink "$TARGET_ENV")"
            if [ "$CURRENT_TARGET" = "$LINK_TARGET" ]; then
                echo "  [OK] Symlink already exists for $stack_dir"
            else
                ln -sfn "$LINK_TARGET" "$TARGET_ENV"
                echo "  [UPDATED] Symlink corrected for $stack_dir"
            fi
        else
            echo "  [WARNING] Found regular file at $TARGET_ENV. Skipping to avoid data loss."
            echo "            Please manually remove or rename it if you want to link it."
        fi
    else
        # Create the symlink
        # We use relative path for the link to be portable if the root folder moves
        ln -s "$LINK_TARGET" "$TARGET_ENV"
        echo "  [CREATED] Linked .env in $stack_dir"
    fi
done

echo "Done."
