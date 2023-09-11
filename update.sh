#!/usr/bin/env bash

# Define the platform function
platform() {
  case "$(uname -s)" in
    Darwin*) echo "darwin" ;;
    *) echo "unknown" ;;
  esac
}

# Run script for specified platform
SCRIPT_DIR=$(dirname -- "${BASH_SOURCE[0]}")
source "$SCRIPT_DIR/update/$(platform).sh"
