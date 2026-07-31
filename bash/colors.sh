#!/usr/bin/env bash
# shellcheck disable=SC2034  # Variables are set here for use by callers that source this file
# bash/colors.sh — ANSI colour variables
#
# Source this file to get colour variables in your script.
# Colours are automatically disabled when stdout is not a terminal.
#
# Exported variables:
#   RED YELLOW GREEN CYAN BOLD RESET
#
# Usage:
#   source "$(dirname "$0")/../../bash-test-libs/bash/colors.sh"
#   echo -e "${GREEN}OK${RESET}"

if [ -t 1 ]; then
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    GREEN='\033[0;32m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    RED=''
    YELLOW=''
    GREEN=''
    CYAN=''
    BOLD=''
    RESET=''
fi
