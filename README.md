# bash-test-libs

**Shared Bash and Python utilities for test automation projects.**

A centralized library of reusable helper functions and classes for test scripts, CI tools, and automation workflows.

---

## What's inside

### Bash libraries (`bash/`)

| Module | What it provides |
|---|---|
| **`colors.sh`** | ANSI colour variables (`RED`, `GREEN`, `YELLOW`, `CYAN`, `BOLD`, `RESET`) — auto-disabled when stdout is not a TTY |
| **`output.sh`** | `emit()` (print + store), `log()`, `warn()`, `error()`, `save_report()` |
| **`results.sh`** | `result_pass()`, `result_fail()`, `result_warn()`, `result_info()` — increments `PASS`/`FAIL`/`WARN` counters |
| **`distro.sh`** | `detect_distro()` — populates `DISTRO_ID`, `DISTRO_NAME`, `DISTRO_VERSION`, `PKG_MGR` |

### Python libraries (`python/`)

| Module | What it provides |
|---|---|
| **`colors.py`** | `Colors` class for ANSI terminal colours, auto-detects TTY, `strip_ansi()` helper |

---

## Usage

### Bash

```bash
#!/usr/bin/env bash
set -euo pipefail

# Adjust path to point to your local clone of bash-test-libs
LIB_DIR="$(dirname "$0")/../../bash-test-libs/bash"

source "$LIB_DIR/colors.sh"
source "$LIB_DIR/output.sh"
source "$LIB_DIR/results.sh"

REPORT_LINES=()
PASS=0; FAIL=0; WARN=0

emit "${BOLD}Starting validation...${RESET}"

if [[ -f /etc/passwd ]]; then
    result_pass "/etc/passwd exists"
else
    result_fail "/etc/passwd missing"
fi

emit ""
emit "${BOLD}Results: ${GREEN}PASS=$PASS${RESET}  ${RED}FAIL=$FAIL${RESET}${RESET}"

[[ -n "${OUTPUT_FILE:-}" ]] && save_report "$OUTPUT_FILE"
```

### Python

```python
#!/usr/bin/env python3
import sys
from pathlib import Path

# Adjust path to point to your local clone of bash-test-libs
sys.path.insert(0, str(Path(__file__).parent.parent / "bash-test-libs" / "python"))

from colors import Colors

c = Colors()  # auto-detect TTY
print(f"{c.GREEN}Tests passed{c.RESET}")
print(f"{c.RED}Tests failed{c.RESET}")

# Strip ANSI codes for file output
plain_text = Colors.strip_ansi(f"{c.GREEN}OK{c.RESET}")
```

---

## Installation

Clone this repo alongside your test projects:

```bash
cd ~/github-trupti/
git clone https://github.com/sawaiwalatrupti/bash-test-libs.git
```

Your projects should reference it with relative paths:

```
~/github-trupti/
├── bash-test-libs/          ← shared library
├── distro-compat-checker/   ← sources ../bash-test-libs/bash/...
├── linux-log-parser/        ← sources ../bash-test-libs/bash/...
└── qa-automation-toolkit/   ← imports  ../bash-test-libs/python/...
```

---

## Why a shared library?

1. **DRY principle** — write once, use in all projects
2. **Single source of truth** — fix a bug in one place, all projects benefit
3. **Consistency** — all scripts use the same colour codes, log format, and report structure
4. **Easier maintenance** — update the library, projects automatically get improvements
5. **Scalability** — add new utilities without touching every project

---

## Projects using this library

- [distro-compat-checker](https://github.com/sawaiwalatrupti/distro-compat-checker) — cross-distro package/service validation tool (Bash)
- [linux-log-parser](https://github.com/sawaiwalatrupti/linux-log-parser) — system log error scanner (Bash)
- [qa-automation-toolkit](https://github.com/sawaiwalatrupti/qa-automation-toolkit) — JUnit XML result analyser (Python)

---

## Requirements

- **Bash**: 4.0+
- **Python**: 3.9+ (for Python modules)
- No external dependencies

---

## Contributing

When adding a new utility:

1. Keep functions small and single-purpose
2. Document parameters and behaviour in a comment header
3. Use `shellcheck` for Bash code (`shellcheck bash/*.sh`)
4. Use `mypy` for Python code (`mypy python/`)
5. Test in both TTY and non-TTY environments

---

## License

MIT
