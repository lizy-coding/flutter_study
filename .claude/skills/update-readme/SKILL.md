---
name: update-readme
description: Updates and maintains the project README.md by scanning modules, extracting metadata, generating indexes, and keeping documentation in sync with codebase changes. Use when adding new modules, removing modules, or refreshing project documentation.
allowed-tools: Read, Grep, Glob, Bash(*), Edit, Write
model: claude-sonnet-4-5-20250929
---

# Project README Updater

A skill to keep the project README.md accurate and comprehensive by automatically scanning the codebase and generating structured documentation.

## What This Skill Does

- **Scan modules** - Discover all modules in `lib/` directory
- **Extract metadata** - Read `AI_ANALYSIS.md`, `module_entry.dart`, and route registrations
- **Update project structure** - Refresh the directory tree in README
- **Generate module index** - Create categorized module listings with descriptions
- **Sync with codebase** - Ensure README reflects current state of the project

## Quick Start

Tell Claude what you need:

### Individual Tasks

- **"Scan all modules"** - Discover and list all modules with their metadata
- **"Update project structure section"** - Refresh the directory tree in README
- **"Update module index"** - Regenerate the categorized module listings
- **"Full README update"** - Scan everything and update README.md completely

### Complete Workflow

- **"Update README"** - Execute full scan and update cycle

## Workflows

### "Scan all modules"

**What happens:**
- Scans `lib/` directory for module folders
- Reads each module's `AI_ANALYSIS.md` for descriptions
- Extracts route registrations from `lib/router/app_route_table.dart`
- Collects metadata (category, difficulty, status)

**→ [Detailed Guide](guides/scan-modules.md)**

---

### "Update project structure"

**What happens:**
- Generates current directory tree of `lib/`
- Updates the project structure section in README
- Preserves formatting and existing annotations

**→ [Detailed Guide](guides/update-structure.md)**

---

### "Update module index"

**What happens:**
- Groups modules by category (UI, Async, State, Network, etc.)
- Extracts descriptions and feature highlights
- Generates markdown tables with links
- Updates the index section in README

**→ [Detailed Guide](guides/update-index.md)**

---

### "Full README update"

**Complete workflow** combining all tasks:
1. Scan all modules
2. Update project structure
3. Regenerate module index
4. Update quick start guide
5. Verify links and references

**→ [Complete Workflow Guide](guides/full-update.md)**

## Available Scripts

Located in `.claude/skills/update-readme/scripts/`:

**Scanning:**
- `scan_modules.sh` - Scan lib/ and extract module information
- `extract_metadata.sh` - Parse AI_ANALYSIS.md and route files

**Generation:**
- `generate_structure.sh` - Generate directory tree for README
- `generate_index.sh` - Generate categorized module index

## Module Metadata Sources

The skill extracts information from:

1. **`lib/AI_MODULE_INDEX.md`** - Module index and descriptions
2. **`lib/router/app_route_table.dart`** - Route registrations with metadata
3. **`<module>/AI_ANALYSIS.md`** - Detailed module analysis
4. **`<module>/module_entry.dart`** - Module entry widget and exports

## Metadata Fields

Each module may provide:

| Field | Source | Description |
|-------|--------|-------------|
| `name` | Directory name | Module identifier |
| `category` | Route registration | ModuleCategory enum |
| `difficulty` | Route registration | Difficulty enum |
| `status` | Route registration | ModuleStatus enum |
| `subtitle` | Route registration | Short description |
| `concepts` | Route registration | Learning concepts |
| `estimatedMinutes` | Route registration | Time to complete |

## When to Use This Skill

**Use when:**
- Adding a new module to the project
- Removing or renaming a module
- Module descriptions are outdated
- Preparing for release or sharing the project
- Onboarding new developers

**Recommended frequency:**
- After each module addition/removal
- Monthly for active development
- Before major releases

## Output Format

Updated README sections follow this structure:

### Project Structure
```
lib/
├── main.dart              # Entry point
├── app.dart               # App shell
├── router/                # Route configuration
├── shared/                # Shared components
├── module_a/              # Module A description
└── module_b/              # Module B description
```

### Module Index (by category)

#### UI 与动效
| 模块 | 描述 | 难度 | 预计时间 |
|------|------|------|----------|
| `module_name` | Short description | beginner | 30min |

## Key Principles

✓ **Non-destructive** - Only updates sections, preserves custom content
✓ **Accurate** - Extracts from source, never guesses
✓ **Categorized** - Groups by ModuleCategory enum
✓ **Linkable** - Ensures all references are valid
✓ **Chinese-first** - Maintains Chinese descriptions as per project convention
