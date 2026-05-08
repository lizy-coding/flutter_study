# Update Module Index Guide

## Purpose
Regenerate the categorized module listings in README.md

## Steps

1. **Collect module metadata**:
   - Read `lib/router/app_route_table.dart`
   - Extract ModuleEntry registrations
   - Parse category, difficulty, subtitle, concepts

2. **Group by category**:
   - ModuleCategory.basic → 基础机制
   - ModuleCategory.async → 异步并发
   - ModuleCategory.state → 状态管理
   - ModuleCategory.ui → UI 与动效
   - ModuleCategory.network → 网络与平台

3. **Generate markdown**:
   For each category:
   ```markdown
   ### Category Name
   | 模块 | 描述 | 难度 | 预计时间 |
   |------|------|------|----------|
   | `module_name` | subtitle | difficulty | estimatedMinutes |
   ```

4. **Update README**:
   - Locate "## 示例索引（按主题）" section
   - Replace with generated content
   - Preserve any additional descriptions or links

## Difficulty Mapping
- `Difficulty.beginner` → 入门
- `Difficulty.intermediate` → 进阶
- `Difficulty.advanced` → 实战

## Status Indicators
Add badges or notes for:
- `ModuleStatus.recommended` → ⭐ 推荐
- `ModuleStatus.ready` → ✓ 可用
- `ModuleStatus.pending` → 🚧 待完善
