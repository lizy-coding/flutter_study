#!/usr/bin/env python3
"""
Find duplicate configuration files.
"""

import os
from pathlib import Path

def find_duplicate_configs(root_path="."):
    """Find duplicate configuration files."""

    if not os.path.isabs(root_path):
        root_path = os.getcwd()

    config_patterns = {
        'pubspec.yaml': [],
        'analysis_options.yaml': [],
        'build.yaml': [],
        'firebase.json': [],
        '.gitignore': [],
        '.flutter-plugins': [],
        'codegen.yaml': []
    }

    for root, dirs, files in os.walk(root_path):
        dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['node_modules', 'build', '.dart_tool']]

        for filename in files:
            if filename in config_patterns:
                filepath = os.path.join(root, filename)
                rel_path = os.path.relpath(filepath, root_path)
                config_patterns[filename].append(rel_path)

    print("=" * 70)
    print("Configuration Files Found")
    print("=" * 70)

    for pattern, paths in config_patterns.items():
        if paths:
            print(f"\n{pattern}: {len(paths)} file(s)")
            for path in paths:
                print(f"  - {path}")

    # Check for duplicates
    print("\n" + "=" * 70)
    print("Consolidation Recommendations")
    print("=" * 70)

    has_duplicates = False

    if config_patterns['pubspec.yaml'] and len(config_patterns['pubspec.yaml']) > 1:
        has_duplicates = True
        print("\n⚠ Multiple pubspec.yaml files found")
        print("  Recommendation: Consolidate into root pubspec.yaml")
        print("  Files to consolidate:")
        for path in config_patterns['pubspec.yaml'][1:]:
            print(f"    - {path}")

    if config_patterns['analysis_options.yaml'] and \
       len(config_patterns['analysis_options.yaml']) > 1:
        has_duplicates = True
        print("\n⚠ Multiple analysis_options.yaml files found")
        print("  Recommendation: Use single root analysis_options.yaml")
        print("  Files to consolidate:")
        for path in config_patterns['analysis_options.yaml'][1:]:
            print(f"    - {path}")

    if config_patterns['.gitignore'] and len(config_patterns['.gitignore']) > 1:
        has_duplicates = True
        print("\n⚠ Multiple .gitignore files found")
        print("  Recommendation: Merge into root .gitignore")
        print("  Files to merge:")
        for path in config_patterns['.gitignore']:
            print(f"    - {path}")

    if not has_duplicates:
        print("\n✓ No duplicate configuration files found!")

    print("\n✓ Analysis complete")

if __name__ == '__main__':
    find_duplicate_configs()
