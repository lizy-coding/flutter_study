#!/usr/bin/env python3
"""
Generate module descriptions by analyzing Dart files.
"""

import os
import re
from pathlib import Path
from collections import defaultdict

def extract_module_info(module_path):
    """Extract information about a module."""
    info = {
        'name': os.path.basename(module_path),
        'path': module_path,
        'description': '',
        'features': [],
        'pages': [],
        'widgets': [],
        'models': [],
        'services': [],
        'file_count': 0,
        'line_count': 0,
        'has_tests': False,
        'dependencies': set()
    }

    # Walk through module directory
    for root, dirs, files in os.walk(module_path):
        # Skip hidden directories
        dirs[:] = [d for d in dirs if not d.startswith('.')]

        # Count Dart files
        dart_files = [f for f in files if f.endswith('.dart')]
        info['file_count'] += len(dart_files)

        # Analyze structure
        rel_path = os.path.relpath(root, module_path)

        # Detect subdirectories
        if 'pages' in rel_path or 'screens' in rel_path:
            info['pages'].extend([f.replace('.dart', '') for f in dart_files if not f.startswith('_')])
        elif 'widgets' in rel_path:
            info['widgets'].extend([f.replace('.dart', '') for f in dart_files if not f.startswith('_')])
        elif 'models' in rel_path:
            info['models'].extend([f.replace('.dart', '') for f in dart_files])
        elif 'services' in rel_path:
            info['services'].extend([f.replace('.dart', '') for f in dart_files])

        # Check for tests
        if 'test' in rel_path:
            info['has_tests'] = True

        # Analyze Dart files for description and dependencies
        for dart_file in dart_files:
            filepath = os.path.join(root, dart_file)

            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    lines = content.split('\n')
                    info['line_count'] += len(lines)

                    # Extract description from comments
                    if not info['description'] and dart_file in ['module_root.dart', 'module_entry.dart']:
                        # Look for class or file-level comments
                        doc_pattern = re.compile(r'///\s*(.+)')
                        comment_pattern = re.compile(r'//\s*(.+)')

                        for line in lines[:50]:  # Check first 50 lines
                            doc_match = doc_pattern.match(line.strip())
                            if doc_match:
                                desc = doc_match.group(1).strip()
                                if len(desc) > 10 and not desc.startswith('@'):
                                    info['description'] = desc
                                    break

                            comment_match = comment_pattern.match(line.strip())
                            if comment_match and not info['description']:
                                desc = comment_match.group(1).strip()
                                if len(desc) > 20:
                                    info['description'] = desc

                    # Extract imports to find dependencies
                    import_pattern = re.compile(r"import\s+['\"]package:([^/]+)/")
                    for match in import_pattern.finditer(content):
                        package = match.group(1)
                        if package not in ['flutter', 'dart']:
                            info['dependencies'].add(package)

                    # Extract features from class names
                    class_pattern = re.compile(r'class\s+(\w+)')
                    for match in class_pattern.finditer(content):
                        class_name = match.group(1)
                        if 'Page' in class_name or 'Screen' in class_name:
                            if class_name not in info['pages']:
                                info['features'].append(class_name.replace('Page', '').replace('Screen', ''))

            except Exception as e:
                print(f"Warning: Could not read {filepath}: {e}")

    # Convert dependencies set to list
    info['dependencies'] = sorted(list(info['dependencies']))

    # Generate description if not found
    if not info['description']:
        info['description'] = f"Flutter module demonstrating {info['name'].replace('_', ' ')} functionality"

    return info

def generate_module_descriptions(lib_path="lib"):
    """Generate descriptions for all modules."""

    if not os.path.exists(lib_path):
        lib_path = os.path.join(os.getcwd(), "lib")

    modules = {}

    # Find all modules (top-level directories in lib/)
    for item in os.listdir(lib_path):
        item_path = os.path.join(lib_path, item)

        # Skip files and hidden directories
        if not os.path.isdir(item_path) or item.startswith('.'):
            continue

        # Skip common non-module directories
        if item in ['router', 'common', 'shared', 'utils', 'config', 'core']:
            continue

        # Extract module info
        module_info = extract_module_info(item_path)
        modules[item] = module_info

    return modules

def print_module_descriptions(modules):
    """Print module descriptions in a formatted way."""

    print("=" * 70)
    print("Module Descriptions")
    print("=" * 70)

    for module_name, info in sorted(modules.items()):
        print(f"\n{module_name}:")
        print(f"  Description: {info['description']}")
        print(f"  Files: {info['file_count']} ({info['line_count']:,} lines)")

        if info['pages']:
            print(f"  Pages: {len(info['pages'])}")
            for page in info['pages'][:3]:
                print(f"    - {page}")
            if len(info['pages']) > 3:
                print(f"    ... and {len(info['pages']) - 3} more")

        if info['widgets']:
            print(f"  Widgets: {len(info['widgets'])}")

        if info['models']:
            print(f"  Models: {len(info['models'])}")

        if info['services']:
            print(f"  Services: {len(info['services'])}")

        if info['dependencies']:
            print(f"  Dependencies: {', '.join(info['dependencies'][:5])}")
            if len(info['dependencies']) > 5:
                print(f"    ... and {len(info['dependencies']) - 5} more")

        if info['has_tests']:
            print(f"  Tests: ✓")

def main():
    modules = generate_module_descriptions()
    print_module_descriptions(modules)

    # Save to JSON for use by other scripts
    import json
    with open('module_descriptions.json', 'w', encoding='utf-8') as f:
        # Convert sets to lists for JSON serialization
        modules_serializable = {}
        for name, info in modules.items():
            modules_serializable[name] = {
                k: (list(v) if isinstance(v, set) else v)
                for k, v in info.items()
            }
        json.dump(modules_serializable, f, indent=2, ensure_ascii=False)

    print("\n" + "=" * 70)
    print(f"✓ Module descriptions saved to: module_descriptions.json")
    print(f"✓ Total modules analyzed: {len(modules)}")

if __name__ == '__main__':
    main()
