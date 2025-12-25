#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_LIB="${ROOT_DIR}/main_app/lib"

mkdir -p "${MAIN_LIB}"

get_pubspec_name() {
  local pubspec_path="$1"
  local name
  name="$(awk -F: '/^name:[[:space:]]*/ {gsub(/[[:space:]]+/, "", $2); print $2; exit}' "${pubspec_path}" || true)"
  if [[ -z "${name}" ]]; then
    name="$(basename "$(dirname "${pubspec_path}")")"
  fi
  echo "${name}"
}

for dir in "${ROOT_DIR}"/*; do
  [[ -d "${dir}" ]] || continue
  base="$(basename "${dir}")"
  [[ "${base}" == "main_app" ]] && continue
  [[ "${base}" == .* ]] && continue

  if [[ -f "${dir}/pubspec.yaml" && -d "${dir}/lib" ]]; then
    pkg="$(get_pubspec_name "${dir}/pubspec.yaml")"
    dest="${MAIN_LIB}/${pkg}"

    if [[ -e "${dest}" ]]; then
      echo "Skip ${base}: target exists -> ${dest}"
      continue
    fi

    echo "Move ${dir}/lib -> ${dest}"
    mv "${dir}/lib" "${dest}"
  fi
done
