#!/usr/bin/env python3
"""
Analyze Flutter project structure and identify issues.
"""

import os
import json
from pathlib import Path
from collections import defaultdict
import re

def analyze_structure(lib_path="lib"):
    """Analyze project structure and return metrics."""

    if not os.path.exists(lib_path):
        lib_path = os.path.join(os.getcwd(), "lib")

    metrics = {
        "modules": {},
        "deep_files": [],
        "large_files": [],
        "duplicate_files": defaultdict(list),
        "import_stats": defaultdict(int),
        "total_lines": 0,
        "file_count": 0,
        "issues": []
    }

    # Walk through lib directory
    for root, dirs, files in os.walk(lib_path):
        # Skip hidden directories
        dirs[:] = [d for d in dirs if not d.startswith('.')]

        depth = len(Path(root).relative_to(lib_path).parts)

        # Analyze Dart files
        for file in files:
            if not file.endswith('.dart'):
                continue

            filepath = os.path.join(root, file)
            module = Path(root).relative_to(lib_path).parts[0] if depth > 0 else 'root'

            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    lines = f.readlines()
                    line_count = len(lines)

                # Track metrics
                metrics['file_count'] += 1
                metrics['total_lines'] += line_count

                # Check file size
                if line_count > 500:
                    metrics['large_files'].append({
                        'path': filepath.replace(lib_path, 'lib'),
                        'lines': line_count
                    })

                # Check depth
                if depth > 4:
                    metrics['deep_files'].append({
                        'path': filepath.replace(lib_path, 'lib'),
                        'depth': depth
                    })

                # Count imports
                import_pattern = re.compile(r'^import\s+["\']')
                for line in lines:
                    if import_pattern.match(line.strip()):
                        metrics['import_stats'][module] += 1

                # Track by module
                if module not in metrics['modules']:
                    metrics['modules'][module] = {
                        'file_count': 0,
                        'line_count': 0,
                        'max_depth': 0
                    }

                metrics['modules'][module]['file_count'] += 1
                metrics['modules'][module]['line_count'] += line_count
                metrics['modules'][module]['max_depth'] = max(
                    metrics['modules'][module]['max_depth'],
                    depth
                )

            except Exception as e:
                metrics['issues'].append(f"Error reading {filepath}: {str(e)}")

    # Identify issues
    for module, stats in metrics['modules'].items():
        if stats['file_count'] > 30:
            metrics['issues'].append(
                f"Module '{module}' has {stats['file_count']} files (>30)"
            )
        if stats['max_depth'] > 4:
            metrics['issues'].append(
                f"Module '{module}' has depth {stats['max_depth']} (>4)"
            )

    return metrics

def main():
    metrics = analyze_structure()

    # Print report
    print("=" * 60)
    print("Flutter Project Structure Analysis")
    print("=" * 60)

    print(f"\nTotal Files: {metrics['file_count']}")
    print(f"Total Lines of Code: {metrics['total_lines']:,}")
    if metrics['file_count'] > 0:
        print(f"Average File Size: {metrics['total_lines'] // metrics['file_count']} lines")

    print("\n" + "=" * 60)
    print("Module Overview")
    print("=" * 60)

    for module, stats in sorted(metrics['modules'].items()):
        print(f"\n{module}:")
        print(f"  Files: {stats['file_count']}")
        print(f"  Lines: {stats['line_count']:,}")
        print(f"  Max Depth: {stats['max_depth']}")
        print(f"  Imports: {metrics['import_stats'].get(module, 0)}")

    if metrics['large_files']:
        print("\n" + "=" * 60)
        print("Large Files (>500 lines) - Consider Refactoring")
        print("=" * 60)
        for item in sorted(metrics['large_files'],
                           key=lambda x: x['lines'],
                           reverse=True):
            print(f"{item['path']}: {item['lines']} lines")

    if metrics['deep_files']:
        print("\n" + "=" * 60)
        print("Deeply Nested Files (>4 levels) - Consider Flattening")
        print("=" * 60)
        for item in sorted(metrics['deep_files'],
                           key=lambda x: x['depth'],
                           reverse=True)[:10]:
            print(f"{item['path']}: depth {item['depth']}")

    if metrics['issues']:
        print("\n" + "=" * 60)
        print("Potential Issues")
        print("=" * 60)
        for issue in metrics['issues']:
            print(f"⚠ {issue}")

    # Save JSON report
    with open('analysis_report.json', 'w') as f:
        json.dump(metrics, f, indent=2)

    print("\n✓ Detailed report saved to: analysis_report.json")

if __name__ == '__main__':
    main()
