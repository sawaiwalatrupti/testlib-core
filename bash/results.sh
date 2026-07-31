#!/usr/bin/env bash
# bash/results.sh — PASS/FAIL/WARN/INFO result helpers for test scripts
#
# Requires: colors.sh and output.sh sourced first.
#
# Provides:
#   result_pass TEXT   — prints [PASS] and increments PASS counter
#   result_fail TEXT   — prints [FAIL] and increments FAIL counter
#   result_warn TEXT   — prints [WARN] and increments WARN counter
#   result_info TEXT   — prints [INFO] (no counter)
#
# Callers must declare:  PASS=0; FAIL=0; WARN=0  before sourcing,
# or the counters are initialised here on first source.

: "${PASS:=0}"
: "${FAIL:=0}"
: "${WARN:=0}"

result_pass() { emit "  ${GREEN}[PASS]${RESET} $1"; PASS=$((PASS + 1)); }
result_fail() { emit "  ${RED}[FAIL]${RESET} $1"; FAIL=$((FAIL + 1)); }
result_warn() { emit "  ${YELLOW}[WARN]${RESET} $1"; WARN=$((WARN + 1)); }
result_info() { emit "  ${CYAN}[INFO]${RESET} $1"; }
