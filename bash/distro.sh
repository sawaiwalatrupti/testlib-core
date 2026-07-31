#!/usr/bin/env bash
# shellcheck disable=SC2034  # Variables are set here for use by callers that source this file
# bash/distro.sh — Linux distribution detection
#
# Provides:
#   detect_distro   — populates DISTRO_ID, DISTRO_NAME, DISTRO_VERSION, PKG_MGR
#
# After calling detect_distro:
#   DISTRO_ID      — short id from /etc/os-release  (e.g. rhel, ubuntu, sles)
#   DISTRO_NAME    — human name                      (e.g. "Red Hat Enterprise Linux")
#   DISTRO_VERSION — VERSION_ID                      (e.g. 9.3, 22.04)
#   PKG_MGR        — "rpm" | "dpkg" | "unknown"

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        DISTRO_ID="${ID:-unknown}"
        DISTRO_NAME="${NAME:-unknown}"
        DISTRO_VERSION="${VERSION_ID:-unknown}"
    else
        DISTRO_ID="unknown"
        DISTRO_NAME="Unknown"
        DISTRO_VERSION="unknown"
    fi

    case "$DISTRO_ID" in
        rhel|centos|fedora|rocky|almalinux) PKG_MGR="rpm"     ;;
        sles|opensuse*)                     PKG_MGR="rpm"     ;;
        ubuntu|debian)                      PKG_MGR="dpkg"    ;;
        *)                                  PKG_MGR="unknown" ;;
    esac
}
