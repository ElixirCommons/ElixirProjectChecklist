#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"; echo $SCRIPT_DIR
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"; echo $ROOT_DIR