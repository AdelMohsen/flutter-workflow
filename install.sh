#!/usr/bin/env bash

set -euo pipefail

repository_url="https://github.com/AdelMohsen/flutter-workflow.git"
engine_ref="${FLUTTER_ENGINE_REF:-main}"
target="$PWD"

if [[ "${1:-}" == "--target" ]]; then
  if [[ -z "${2:-}" ]]; then
    echo "Missing value for --target" >&2
    exit 64
  fi
  target="$2"
elif [[ $# -gt 0 ]]; then
  echo "Usage: install.sh [--target /path/to/flutter-project]" >&2
  exit 64
fi

command -v git >/dev/null || {
  echo "Git is required." >&2
  exit 127
}
command -v dart >/dev/null || {
  echo "Dart is required." >&2
  exit 127
}

temporary_directory="$(mktemp -d "${TMPDIR:-/tmp}/flutter-workflow.XXXXXX")"
trap 'rm -rf -- "$temporary_directory"' EXIT

git clone --depth 1 --branch "$engine_ref" --quiet \
  "$repository_url" "$temporary_directory/repository"
dart run "$temporary_directory/repository/install.dart" --target "$target"
