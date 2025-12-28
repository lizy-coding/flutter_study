# Clean Up Redundant Documentation

Identify and remove duplicate or outdated documentation files to keep your project lean and maintainable.

## What This Does

Finds and helps you consolidate:
- Duplicate README files in subdirectories
- Outdated CHANGELOG entries
- Duplicate API documentation
- Overlapping architecture documentation
- Redundant guide files
- Deprecated documentation

## Quick Start

```bash
python .claude/skills/project-simplification/scripts/find_redundant_docs.py
```

## Manual Search

You can also manually search for documentation:

```bash
# Find all markdown files
find . -name "*.md" -type f

# Search for common doc patterns
grep -r "README\|CHANGELOG\|API" . --include="*.md"
```

## Cleanup Process

For each redundant document found, follow these steps:

### 1. Review Content
- Read the document thoroughly
- Check if it contains unique information
- Identify if content is duplicated elsewhere
- Assess its value to the project

### 2. Check References

Find all places that link to this document:

```bash
# Find references to this doc
grep -r "path/to/doc.md" .

# Check for URL references
grep -r "docs/file-name" .
```

### 3. Merge Content

If the document has unique content:
- Merge into primary documentation
- Update primary doc with any missing information
- Preserve important historical context
- Ensure no valuable information is lost

### 4. Delete Redundant File

```bash
git rm path/to/redundant/doc.md
```

### 5. Update References

- Update all files that referenced the removed doc
- Redirect links to the consolidated documentation
- Update table of contents if applicable
- Verify no broken links remain

## Common Redundant Docs in Flutter Projects

### Duplicate READMEs
- **Issue**: Multiple README files with overlapping content
- **Solution**: Keep one comprehensive README per module
- **Common locations**: Feature subdirectories, lib/ folders
- **Action**: Consolidate unique content into main module README

### Outdated CHANGELOGs
- **Issue**: Unmaintained or duplicate changelog files
- **Solution**: Maintain single CHANGELOG.md at project root
- **Action**: Archive or consolidate old entries
- **Best Practice**: Use consistent format (e.g., Keep a Changelog)

### Duplicate API Docs
- **Issue**: Multiple API documentation files with same content
- **Solution**: Use single API reference or auto-generated docs
- **Tool**: Consider using `dartdoc` for API documentation
- **Action**: Remove manual API docs in favor of code comments + dartdoc

### Architecture Docs
- **Issue**: Overlapping architecture descriptions across files
- **Solution**: Single `architecture.md` or wiki page
- **Content**: Keep high-level overview in main docs
- **Detail**: Link to external resources for deep dives

### Migration Guides
- **Issue**: Old migration guides no longer relevant
- **Solution**: Remove guides for versions no longer supported
- **Archive**: Consider moving to `/docs/archive/` if historical value

## Custom Pattern Search

Search for specific documentation patterns:

```bash
DOC_PATTERNS="README,CHANGELOG,GUIDE,API" python .claude/skills/project-simplification/scripts/find_redundant_docs.py
```

## Decision Matrix

Use this to decide what to do with each doc:

| Situation | Action |
|-----------|--------|
| Exact duplicate | Delete, keep one copy |
| Partially overlapping | Merge, delete redundant parts |
| Outdated info | Update or delete entirely |
| Never referenced | Evaluate value, likely delete |
| Historical value | Move to `/docs/archive/` |
| Unique + valuable | Keep and improve |

## Validation

After cleanup, verify:

- [ ] All remaining docs are actively referenced
- [ ] No broken links exist in the project
- [ ] Primary documentation is comprehensive
- [ ] Git history preserved important information
- [ ] Team knows where to find all documentation
- [ ] README files follow consistent structure
- [ ] Documentation index/TOC is updated

## Best Practices

### One Source of Truth
- Keep single authoritative doc per topic
- Avoid duplicating information
- Use links to reference related content

### Clear Organization
- Use consistent naming conventions
- Follow predictable structure
- Group related docs together

### Link Maintenance
- Update all references when moving docs
- Use relative paths for internal links
- Verify links after changes

### Version Control
- Commit cleanups with clear messages
- Document why docs were removed
- Keep commit history clean and descriptive

### Team Communication
- Notify team of documentation changes
- Update onboarding materials
- Share new documentation locations

## Tips

- **Be Conservative**: When in doubt, keep it (but improve it)
- **Involve Team**: Get consensus on removing shared docs
- **Update Tools**: Fix IDE bookmarks, browser favorites
- **Regular Audits**: Schedule periodic documentation reviews

## Next Steps

After cleaning documentation:

1. **Commit changes**:
   ```bash
   git add .
   git commit -m "docs: clean redundant documentation"
   ```

2. **Choose next action**:
   - Continue to [Merge Configuration Files](merge-configs.md)
   - Or go to [Complete Workflow](complete-workflow.md)

3. **Maintain cleanliness**:
   - Add doc review to regular workflow
   - Prevent future duplication
