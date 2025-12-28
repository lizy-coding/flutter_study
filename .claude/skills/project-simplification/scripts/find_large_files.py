#!/usr/bin/env python3
"""
Find large Dart files that should be refactored.
"""

import os
from pathlib import Path

def find_large_files(lib_path="lib", threshold=500):
    """Find Dart files exceeding size threshold."""

    if not os.path.exists(lib_path):
        lib_path = os.path.join(os.getcwd(), "lib")

    large_files = []

    for root, dirs, files in os.walk(lib_path):
        dirs[:] = [d for d in dirs if not d.startswith('.')]

        for file in files:
            if not file.endswith('.dart'):
                continue

            filepath = os.path.join(root, file)

            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    lines = f.readlines()

                line_count = len(lines)

                if line_count > threshold:
                    rel_path = os.path.relpath(filepath, lib_path)
                    large_files.append({
                        'path': rel_path,
                        'lines': line_count,
                        'full_path': filepath
                    })

            except Exception as e:
                print(f"Error reading {filepath}: {e}")

    # Sort by size
    large_files.sort(key=lambda x: x['lines'], reverse=True)

    print("=" * 70)
    print(f"Large Dart Files (>{threshold} lines) - Candidates for Refactoring")
    print("=" * 70)

    if not large_files:
        print(f"\n✓ No files exceed {threshold} lines threshold!")
        return

    print(f"\nFound {len(large_files)} files to consider:")
    print()

    for item in large_files:
        print(f"{item['path']:<50} {item['lines']:>6} lines")

    # Analyze classes in large files
    print("\n" + "=" * 70)
    print("Class Analysis in Large Files")
    print("=" * 70)

    for item in large_files[:5]:  # Top 5 largest files
        filepath = item['full_path']
        try:
            with open(filepath, 'r') as f:
                content = f.read()

            # Simple class detection
            classes = [line.strip() for line in content.split('\n')
                      if line.strip().startswith('class ')]

            print(f"\n{item['path']} ({item['lines']} lines)")
            print(f"  Classes: {len(classes)}")
            for cls in classes[:3]:
                print(f"    - {cls[:60]}")
            if len(classes) > 3:
                print(f"    ... and {len(classes) - 3} more")

        except Exception as e:
            print(f"  Error analyzing: {e}")

    print("\n✓ Analysis complete")

if __name__ == '__main__':
    import sys
    threshold = int(os.environ.get('FILE_SIZE_THRESHOLD', 500))
    find_large_files(threshold=threshold)
