/*
 * testlib-core/c/testlib.h — lightweight C test helpers
 *
 * Usage:
 *   #include "testlib.h"
 *
 *   int main(void) {
 *       TL_INIT();
 *       TL_ASSERT(1 + 1 == 2, "basic math");
 *       TL_ASSERT_STR_EQ("foo", "foo", "string equality");
 *       TL_SUMMARY();
 *       return tl_fail_count > 0 ? 1 : 0;
 *   }
 */

#ifndef TESTLIB_CORE_H
#define TESTLIB_CORE_H

#include <stdio.h>
#include <string.h>

/* ── ANSI colours (disabled when not a TTY) ─────────────────────────────── */
#ifdef _WIN32
#  define TL_RED    ""
#  define TL_GREEN  ""
#  define TL_YELLOW ""
#  define TL_RESET  ""
#else
#  define TL_RED    "\033[0;31m"
#  define TL_GREEN  "\033[0;32m"
#  define TL_YELLOW "\033[0;33m"
#  define TL_RESET  "\033[0m"
#endif

/* ── counters ────────────────────────────────────────────────────────────── */
static int tl_pass_count = 0;
static int tl_fail_count = 0;

/* ── macros ──────────────────────────────────────────────────────────────── */

#define TL_INIT() \
    do { tl_pass_count = 0; tl_fail_count = 0; } while (0)

#define TL_ASSERT(expr, label) \
    do { \
        if (expr) { \
            printf("  " TL_GREEN "[PASS]" TL_RESET " %s\n", label); \
            tl_pass_count++; \
        } else { \
            printf("  " TL_RED "[FAIL]" TL_RESET " %s  (%s:%d)\n", \
                   label, __FILE__, __LINE__); \
            tl_fail_count++; \
        } \
    } while (0)

#define TL_ASSERT_STR_EQ(a, b, label) \
    TL_ASSERT(strcmp((a), (b)) == 0, label)

#define TL_ASSERT_INT_EQ(a, b, label) \
    TL_ASSERT((a) == (b), label)

#define TL_SUMMARY() \
    do { \
        printf("\n  Results: " \
               TL_GREEN "PASS: %d" TL_RESET "   " \
               TL_RED   "FAIL: %d" TL_RESET "\n", \
               tl_pass_count, tl_fail_count); \
    } while (0)

#endif /* TESTLIB_CORE_H */
