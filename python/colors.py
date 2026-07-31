"""
python/colors.py — ANSI colour helpers shared across Python test tools.

Usage:
    from colors import Colors

    c = Colors(enabled=sys.stdout.isatty())
    print(f"{c.GREEN}OK{c.RESET}")
    plain = Colors.strip_ansi(line)   # remove ANSI codes from a string
"""

import re

_ANSI_RE = re.compile(r'\x1b\[[0-9;]*m')


class Colors:
    """ANSI colour codes.  Pass enabled=False to suppress all codes."""

    def __init__(self, enabled: bool = True):
        if enabled:
            self.RED    = '\033[0;31m'
            self.YELLOW = '\033[0;33m'
            self.GREEN  = '\033[0;32m'
            self.CYAN   = '\033[0;36m'
            self.BOLD   = '\033[1m'
            self.RESET  = '\033[0m'
        else:
            self.RED = self.YELLOW = self.GREEN = ''
            self.CYAN = self.BOLD = self.RESET = ''

    @staticmethod
    def strip_ansi(text: str) -> str:
        """Remove all ANSI escape codes from *text*."""
        return _ANSI_RE.sub('', text)
