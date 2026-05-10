# Update Project Structure Guide

## Purpose
Generate and update the directory tree section in README.md

## Steps

1. **Generate tree**:
   ```bash
   tree lib/ -L 1 --dirsfirst -I '__pycache__|.dart_tool'
   ```
   
   Or manually format if `tree` not available:
   ```bash
   ls -1 lib/
   ```

2. **Add annotations**:
   - Read existing README for annotation style
   - Match format: `├── filename/  # Description`
   - Use descriptions from AI_MODULE_INDEX.md or AI_ANALYSIS.md

3. **Update README**:
   - Locate the "## 项目结构" section
   - Replace the code block with new tree
   - Preserve any manual annotations

## Format Example
```
lib/
├── main.dart              # 入口
├── app.dart               # 应用主壳
├── router/                # 路由配置
├── shared/                # 共享组件
├── module_a/              # 模块 A 描述
└── module_b/              # 模块 B 描述
```
