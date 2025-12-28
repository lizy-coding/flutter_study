#!/usr/bin/env python3
"""
Find redundant or duplicate documentation files.
"""

import os
from pathlib import Path
from difflib import SequenceMatcher

def find_redundant_docs(root_path="."):
    """Find potentially redundant documentation."""

    if not os.path.isabs(root_path):
        root_path = os.getcwd()

    docs = {}
    redundant = []

    # Find all markdown files
    for root, dirs, files in os.walk(root_path):
        dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['node_modules', 'build', '.dart_tool']]

        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                rel_path = os.path.relpath(filepath, root_path)

                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()

                    docs[rel_path] = {
                        'content': content,
                        'size': len(content),
                        'basename': file
                    }
                except Exception as e:
                    print(f"Error reading {filepath}: {e}")

    # Find duplicates by basename
    basenames = {}
    for path, data in docs.items():
        basename = data['basename']
        if basename not in basenames:
            basenames[basename] = []
        basenames[basename].append(path)

    print("=" * 70)
    print("Redundant Documentation Analysis")
    print("=" * 70)

    # Check for files with same name
    for basename, paths in basenames.items():
        if len(paths) > 1:
            print(f"\n⚠ Potential Duplicates: {basename}")
            for path in paths:
                size = docs[path]['size']
                print(f"  {path} ({size} bytes)")

            # Check content similarity
            if len(paths) == 2:
                content1 = docs[paths[0]]['content']
                content2 = docs[paths[1]]['content']
                similarity = SequenceMatcher(None, content1, content2).ratio()
                print(f"  Similarity: {similarity:.1%}")

    # Known redundant patterns
    print("\n" + "=" * 70)
    print("Redundant Documentation Patterns")
    print("=" * 70)

    readme_files = [p for p in docs if p.endswith('README.md')]
    if len(readme_files) > 1:
        print(f"\n⚠ Multiple README.md files found ({len(readme_files)})")
        for path in sorted(readme_files):
            print(f"  {path}")

    # Check for outdated changelog entries
    changelog_files = [p for p in docs if 'CHANGELOG' in p.upper()]
    if len(changelog_files) > 1:
        print(f"\n⚠ Multiple changelog files found ({len(changelog_files)})")
        for path in sorted(changelog_files):
            print(f"  {path}")

    # Check for migration-related docs
    migration_files = [p for p in docs if 'MIGRATION' in p.upper() or 'PHASE' in p.upper()]
    if migration_files:
        print(f"\n⚠ Migration-related documentation found ({len(migration_files)})")
        print("  Consider removing if migration is complete:")
        for path in sorted(migration_files):
            print(f"  {path}")

    print("\n" + "=" * 70)
    print(f"Total Documentation Files: {len(docs)}")
    print("=" * 70)

    print("\n✓ Analysis complete")

if __name__ == '__main__':
    find_redundant_docs()
