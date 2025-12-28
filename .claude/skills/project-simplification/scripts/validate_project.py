#!/usr/bin/env python3
"""
Validate project structure and run quality checks.
"""

import subprocess
import os
import sys

def run_command(cmd, description):
    """Run a command and report results."""
    print(f"\n{'=' * 70}")
    print(f"{description}")
    print(f"{'=' * 70}")

    try:
        result = subprocess.run(cmd,
                                shell=True,
                                capture_output=True,
                                text=True)

        if result.stdout:
            print(result.stdout)
        if result.stderr and result.returncode != 0:
            print("STDERR:", result.stderr)

        status = "✓ PASS" if result.returncode == 0 else "✗ FAIL"
        print(f"\nStatus: {status}")

        return result.returncode == 0

    except Exception as e:
        print(f"Error running command: {e}")
        return False

def main():
    print("=" * 70)
    print("Flutter Project Validation Suite")
    print("=" * 70)

    results = {}

    # 1. Check Flutter version
    results['flutter_version'] = run_command(
        "flutter --version",
        "1. Flutter Version"
    )

    # 2. Get dependencies
    results['pub_get'] = run_command(
        "flutter pub get",
        "2. Get Dependencies (flutter pub get)"
    )

    # 3. Run analysis
    results['analyze'] = run_command(
        "flutter analyze",
        "3. Static Analysis (flutter analyze)"
    )

    # 4. Check for formatting issues
    results['format_check'] = run_command(
        "dart format --set-exit-if-changed --output=none lib/",
        "4. Code Format Check"
    )

    # 5. Run tests (if available)
    test_dir = os.path.join(os.getcwd(), "test")
    if os.path.exists(test_dir) and os.listdir(test_dir):
        results['tests'] = run_command(
            "flutter test",
            "5. Run Tests"
        )
    else:
        print("\n" + "=" * 70)
        print("5. Run Tests")
        print("=" * 70)
        print("\n⚠ No tests found - skipping")
        results['tests'] = True

    # Summary
    print("\n" + "=" * 70)
    print("Validation Summary")
    print("=" * 70)

    for check, passed in results.items():
        status = "✓" if passed else "✗"
        print(f"{status} {check}")

    all_passed = all(results.values())

    print("\n" + "=" * 70)
    if all_passed:
        print("✓ All validations passed!")
    else:
        print("✗ Some validations failed. Review the output above.")
    print("=" * 70)

    return 0 if all_passed else 1

if __name__ == '__main__':
    sys.exit(main())
