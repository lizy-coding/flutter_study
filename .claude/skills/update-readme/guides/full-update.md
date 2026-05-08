# Full README Update Workflow

## Overview
Complete cycle to sync README.md with current project state.

## Sequence

### Phase 1: Discovery
1. Run module scan ([scan-modules.md](scan-modules.md))
2. Verify all modules have required files
3. Note any missing AI_ANALYSIS.md files

### Phase 2: Structure Update
1. Generate new directory tree ([update-structure.md](update-structure.md))
2. Compare with existing structure
3. Note added/removed/renamed modules

### Phase 3: Index Regeneration
1. Generate categorized index ([update-index.md](update-index.md))
2. Group modules by category
3. Include difficulty and time estimates

### Phase 4: Sections Review
1. **推荐学习顺序** - Update if new modules added
2. **支持平台** - Verify current platform support
3. **环境与快速开始** - Update Flutter/Dart versions if needed

### Phase 5: Validation
1. Check all module links are valid
2. Verify category assignments
3. Ensure descriptions are current
4. Run `flutter analyze` to confirm project health

## Post-Update
- Commit changes with message: `docs: update README with latest module structure`
- Consider updating AI_PROJECT_CONTEXT.md if major changes

## Checklist
- [ ] All modules in lib/ are documented
- [ ] Project structure tree is accurate
- [ ] Module index covers all modules
- [ ] Categories match ModuleCategory enum
- [ ] Difficulty levels are set
- [ ] Learning order is current
- [ ] No broken references
