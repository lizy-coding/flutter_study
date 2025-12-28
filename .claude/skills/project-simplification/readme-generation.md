# README 生成指南

## 概述

本文档说明如何使用自动化工具生成模块 README 和根路径 README。

## 工作流程

### 步骤 1: 生成模块描述

首先运行脚本分析所有模块并生成描述信息：

```bash
python3 .claude/skills/project-simplification/scripts/generate_module_descriptions.py
```

**输出**:
- `module_descriptions.json` - 包含所有模块的详细信息

**生成的信息包括**:
- 模块名称和描述
- 文件统计（文件数、代码行数）
- 页面、Widget、Model、Service 列表
- 依赖项列表
- 是否包含测试

### 步骤 2: 生成模块 README

使用生成的描述信息为每个模块创建 README：

```bash
python3 .claude/skills/project-simplification/scripts/generate_module_readmes.py
```

**输出**:
- `lib/<module_name>/README.md` - 每个模块的 README 文件

**README 包含内容**:
- 模块概述和功能特性
- 项目结构树
- 使用方法和代码示例
- 技术栈和依赖项
- 文件统计信息

### 步骤 3: 生成根路径 README

汇总所有模块信息，生成项目根路径的 README：

```bash
python3 .claude/skills/project-simplification/scripts/generate_root_readme.py
```

**输出**:
- `README.md` - 项目根路径的 README 文件

**README 包含内容**:
- 项目概述和统计
- 完整的模块列表（带链接）
- 模块分类（UI/异步/架构/网络）
- 学习路径建议
- 快速开始指南
- 项目结构
- 技术栈和资源

## 一次性执行所有步骤

可以使用以下命令依次执行所有步骤：

```bash
python3 .claude/skills/project-simplification/scripts/generate_module_descriptions.py && \
python3 .claude/skills/project-simplification/scripts/generate_module_readmes.py && \
python3 .claude/skills/project-simplification/scripts/generate_root_readme.py
```

或使用 Claude Code Skill:

```
"Generate README files for all modules"
```

## README 模板定制

### 模块 README 模板

模板位于 `generate_module_readmes.py` 中的 `MODULE_README_TEMPLATE` 变量。

**可定制部分**:
- 章节标题和顺序
- 代码示例格式
- 技术栈展示方式
- 附加信息部分

### 根路径 README 模板

模板位于 `generate_root_readme.py` 中的 `ROOT_README_TEMPLATE` 变量。

**可定制部分**:
- 项目介绍和徽章
- 模块分类逻辑
- 学习路径推荐
- 资源链接列表

## 自动化描述生成

脚本会尝试从以下来源提取模块描述：

1. **文档注释** - 从 `module_root.dart` 或 `module_entry.dart` 的注释中提取
2. **类名分析** - 从主要类名推断功能
3. **目录结构** - 根据子目录名称判断模块类型
4. **默认描述** - 如果无法自动识别，使用通用描述

### 手动优化描述

生成后，建议检查并手动优化以下内容：

1. 模块描述的准确性
2. 代码示例的实用性
3. 学习路径的合理性
4. 链接的有效性

## 示例输出

### 模块 README 示例结构

```markdown
# module_name

> 模块描述

## 概述
## 功能特性
## 项目结构
## 主要文件
## 使用方法
## 代码示例
## 技术栈
## 文件统计
## 依赖项
## 测试
## 相关资源
## 更新日志
```

### 根路径 README 示例结构

```markdown
# 项目标题

## 项目概述
## 模块列表
## 快速开始
## 模块分类
## 学习路径
## 技术栈
## 项目结构
## 开发工具
## 学习资源
## 贡献指南
## 更新日志
## 许可证
## 联系方式
```

## 最佳实践

1. **定期更新** - 在添加新模块或修改现有模块后重新生成 README
2. **手动审核** - 自动生成后检查内容的准确性
3. **保持一致** - 使用统一的模板和风格
4. **添加示例** - 为每个模块补充实用的代码示例
5. **更新链接** - 确保所有内部链接有效

## 故障排查

### 模块描述为空

**原因**: 脚本无法从代码中提取描述

**解决方案**:
1. 在 `module_entry.dart` 或 `module_root.dart` 顶部添加文档注释
2. 使用 `///` 注释格式
3. 手动编辑 `module_descriptions.json`

### README 链接失效

**原因**: 文件路径变更或模块重命名

**解决方案**:
1. 重新运行生成脚本
2. 检查文件路径
3. 手动修正链接

### 依赖项缺失

**原因**: 脚本仅分析 import 语句

**解决方案**:
1. 检查 `pubspec.yaml` 中的依赖
2. 手动添加到模块 README
3. 更新 `module_descriptions.json`

## 高级用法

### 自定义模块分类

编辑 `generate_root_readme.py` 中的 `categorize_modules()` 函数：

```python
def categorize_modules(modules):
    categories = {
        'ui': [],
        'async': [],
        'arch': [],
        'network': [],
        'custom': []  # 添加自定义分类
    }
    # 自定义分类逻辑
    ...
```

### 添加额外的统计信息

编辑 `generate_module_descriptions.py` 中的 `extract_module_info()` 函数添加新的分析逻辑。

## 相关工具

- **analyze_structure.py** - 项目结构分析
- **find_large_files.py** - 查找需要拆分的大文件
- **validate_project.py** - 验证项目完整性

## 总结

README 生成工具可以：
- 自动分析所有模块
- 生成一致格式的文档
- 节省手动编写时间
- 保持文档更新

建议在项目重构或添加新模块后运行这些脚本，确保文档始终保持最新。
