#!/usr/bin/env bash
# bash/output.sh — shared emit, logging, and report-save helpers
#
# Requires: colors.sh sourced first (RED, YELLOW, GREEN, CYAN, RESET)
#
# Provides:
#   emit TEXT          — print a line and append it to REPORT_LINES[]
#   log  TEXT          — [INFO]  prefix, stdout only (not stored)
#   warn TEXT          — [WARN]  prefix, stdout only (not stored)
#   error TEXT         — [ERROR] prefix, stdout only (not stored)
#   save_report FILE   — write REPORT_LINES[] to FILE, ANSI codes stripped
#
# Callers must declare:  REPORT_LINES=()  before sourcing this file,
# or the array is initialised here on first source.

: "${REPORT_LINES:=()}"   # no-op if already declared by caller

emit() {
    echo -e "$1"
    REPORT_LINES+=("$1")
}

log()   { echo -e "${CYAN}[INFO]${RESET}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${RESET}  $*"; }
error() { echo -e "${RED}[ERROR]${RESET} $*"; }

# save_report FILE
# Strips ANSI escape sequences and writes the accumulated report to FILE.
save_report() {
    local out="$1"
    printf '%s\n' "${REPORT_LINES[@]}" | sed 's/\x1b\[[0-9;]*m//g' > "$out"
    log "Report saved to: $out"
}
