#!/usr/bin/env bash
# Runs `vaultscan gate`, publishes the report to the job summary and sets the
# action outputs. Inputs arrive as INPUT_* environment variables so nothing
# user-controlled is ever expanded into the script text.
set -euo pipefail

args=(gate --path "${INPUT_PATH:-.}")
[ -n "${INPUT_PLAN:-}" ] && args+=(--plan "$INPUT_PLAN")
[ -n "${INPUT_MANIFESTS:-}" ] && args+=(--manifests "$INPUT_MANIFESTS")
[ -n "${INPUT_POLICY:-}" ] && args+=(--policy "$INPUT_POLICY")
[ "${INPUT_AI:-false}" = "true" ] && args+=(--ai)

report="${RUNNER_TEMP:-/tmp}/vaultscan-report.json"

# The JSON run decides the result. 0 = ALLOW/WARN, 1 = ASK HUMAN/BLOCK,
# anything else means the scanner itself could not run.
set +e
vaultscan "${args[@]}" --format json --output "$report"
code=$?
set -e
if [ "$code" -gt 1 ]; then
  echo "::error::VaultScan could not run (exit code $code). Check the path, plan and manifests inputs."
  exit "$code"
fi

verdict="$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["verdict"])' "$report")"

# Human-readable copies: a table in the log and Markdown in the job summary.
vaultscan "${args[@]}" || true
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  vaultscan "${args[@]}" --format markdown >> "$GITHUB_STEP_SUMMARY" || true
fi

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  {
    echo "verdict=$verdict"
    echo "report=$report"
  } >> "$GITHUB_OUTPUT"
fi

if [ "$code" -eq 1 ]; then
  if [ "${INPUT_FAIL_ON_FINDINGS:-true}" = "true" ]; then
    echo "::error::VaultScan verdict: ${verdict//_/ }"
    exit 1
  fi
  echo "::warning::VaultScan verdict: ${verdict//_/ } (not failing because fail-on-findings is false)"
fi
