#!/usr/bin/env bash

# Define the platform function
platform() {
  case "$(uname -s)" in
    Darwin*) echo "darwin" ;;
    *) echo "unknown" ;;
  esac
}

# Get the platform name
source "./setup/$(platform).sh"
