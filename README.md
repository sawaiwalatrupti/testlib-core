# testlib-core

![CI](https://github.com/sawaiwalatrupti/testlib-core/actions/workflows/ci.yml/badge.svg)

**Shared test utility library for automation projects — Bash, Python, C, and beyond.**

A centralised collection of reusable helpers, colour output utilities, result tracking,
and OS detection functions. Designed to be cloned once and sourced/imported by any
test automation project, keeping common logic in one place.

---

## Repository layout

```
testlib-core/
├── bash/
│   ├── colors.sh       — ANSI colour variables, auto-disabled in non-TTY
│   ├── output.sh       — emit(), log(), warn(), error(), save_report()
│   ├── results.sh      — result_pass/fail/warn/info + PASS/FAIL/WARN counters
│   └── distro.sh       — detect_distro() → DISTRO_ID, DISTRO_NAME, PKG_MGR
├── python/
│   └── colors.py       — Colors class + Colors.strip_ansi()
└── c/
    └── testlib.h       — TL_ASSERT, TL_ASSERT_STR_EQ, TL_SUMMARY macros
```

---

## Installation

Clone once alongside your projects:

```bash
cd ~/github-trupti/
git clone https://github.com/sawaiwalatrupti/testlib-core.git
```

Recommended layout:

```
~/github-trupti/
├── testlib-core/           ← shared library (this repo)
├── distro-compat-checker/  ← sources ../testlib-core/bash/
├── linux-log-parser/       ← sources ../testlib-core/bash/
├── qa-automation-toolkit/  ← imports  ../testlib-core/python/
└── your-next-project/      ← use any language module
```

---

## Usage

### Bash

```bash
#!/usr/bin/env bash
set -euo pipefail

LIB="$(dirname "$0")/../../testlib-core/bash"

source "$LIB/colors.sh"
source "$LIB/output.sh"
source "$LIB/results.sh"
source "$LIB/distro.sh"   # optional — only if you need distro detection

REPORT_LINES=()
PASS=0; FAIL=0; WARN=0

detect_distro
emit "${BOLD}Running on: $DISTRO_NAME $DISTRO_VERSION${RESET}"

[[ -f /etc/passwd ]] && result_pass "/etc/passwd exists" || result_fail "/etc/passwd missing"

emit ""
emit "Results: ${GREEN}PASS=$PASS${RESET}  ${RED}FAIL=$FAIL${RESET}"
save_report "/tmp/my_report.txt"
```

### Python

```python
#!/usr/bin/env python3
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "testlib-core" / "python"))

from colors import Colors

c = Colors(enabled=sys.stdout.isatty())
print(f"{c.GREEN}PASS{c.RESET} — test completed")
plain = Colors.strip_ansi(f"{c.RED}FAIL{c.RESET}")  # for file output
```

### C

```c
#include "../../testlib-core/c/testlib.h"

int main(void) {
    TL_INIT();
    TL_ASSERT(2 + 2 == 4,      "basic arithmetic");
    TL_ASSERT_STR_EQ("a", "a", "string equality");
    TL_ASSERT_INT_EQ(42, 42,   "integer equality");
    TL_SUMMARY();
    return tl_fail_count > 0 ? 1 : 0;
}
```

Compile and run:
```bash
gcc -o test_example test_example.c && ./test_example
```

---

## Module reference

### `bash/colors.sh`
| Variable | Value (TTY) |
|---|---|
| `RED` | `\033[0;31m` |
| `YELLOW` | `\033[0;33m` |
| `GREEN` | `\033[0;32m` |
| `CYAN` | `\033[0;36m` |
| `BOLD` | `\033[1m` |
| `RESET` | `\033[0m` |

### `bash/output.sh`
| Function | Description |
|---|---|
| `emit TEXT` | Print line and append to `REPORT_LINES[]` |
| `log TEXT` | `[INFO]` prefix, stdout only |
| `warn TEXT` | `[WARN]` prefix, stdout only |
| `error TEXT` | `[ERROR]` prefix, stdout only |
| `save_report FILE` | Write `REPORT_LINES[]` to FILE, ANSI stripped |

### `bash/results.sh`
| Function | Description |
|---|---|
| `result_pass TEXT` | Print `[PASS]`, increment `PASS` |
| `result_fail TEXT` | Print `[FAIL]`, increment `FAIL` |
| `result_warn TEXT` | Print `[WARN]`, increment `WARN` |
| `result_info TEXT` | Print `[INFO]`, no counter |

### `bash/distro.sh`
| Variable set | Example |
|---|---|
| `DISTRO_ID` | `rhel`, `ubuntu`, `sles` |
| `DISTRO_NAME` | `Red Hat Enterprise Linux` |
| `DISTRO_VERSION` | `9.3`, `22.04` |
| `PKG_MGR` | `rpm`, `dpkg`, `unknown` |

### `python/colors.py`
| Item | Description |
|---|---|
| `Colors(enabled)` | Class with `RED/YELLOW/GREEN/CYAN/BOLD/RESET` attributes |
| `Colors.strip_ansi(text)` | Static method — removes all ANSI codes from string |

### `c/testlib.h`
| Macro | Description |
|---|---|
| `TL_INIT()` | Reset pass/fail counters |
| `TL_ASSERT(expr, label)` | Assert any boolean expression is true |
| `TL_ASSERT_STR_EQ(a, b, label)` | Assert two C strings are equal (`strcmp`) |
| `TL_ASSERT_INT_EQ(a, b, label)` | Assert two integers are equal |
| `TL_SUMMARY()` | Print final PASS/FAIL count summary |
| `tl_fail_count` | Integer — use in `return tl_fail_count > 0 ? 1 : 0` |

---

## Projects using testlib-core

- [distro-compat-checker](https://github.com/sawaiwalatrupti/distro-compat-checker) — cross-distro package/service validation (Bash)
- [linux-log-parser](https://github.com/sawaiwalatrupti/linux-log-parser) — system log error scanner (Bash)
- [qa-automation-toolkit](https://github.com/sawaiwalatrupti/qa-automation-toolkit) — JUnit XML result analyser (Python)

---

## Contributing

When adding a new module:
1. Place it in the correct language directory (`bash/`, `python/`, `c/`, etc.)
2. Keep each file single-purpose with a clear header comment
3. Document all public functions/macros in this README
4. Validate: `shellcheck bash/*.sh` for Bash, `python3 -m py_compile` for Python, `gcc -fsyntax-only` for C

---

## Requirements

| Language | Minimum version |
|---|---|
| Bash | 4.0+ |
| Python | 3.9+ |
| C | C99 (any gcc/clang) |

---

## License

MIT
