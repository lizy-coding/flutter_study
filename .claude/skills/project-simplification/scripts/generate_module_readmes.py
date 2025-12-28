#!/usr/bin/env python3
"""
Generate README files for each module.
"""

import os
import json
from pathlib import Path
from datetime import datetime

# README template for modules
MODULE_README_TEMPLATE = """# {module_name}

> {description}

## 概述

{overview}

## 功能特性

{features}

## 项目结构

```
{module_name}/
{structure}
```

## 主要文件

{main_files}

## 使用方法

### 1. 导航到模块

在主应用中，模块已自动注册到路由表：

```dart
import 'package:main_app/{module_name}/module_entry.dart';

// 使用 GoRouter 导航
context.push('/{module_route}');
```

### 2. 运行示例

```bash
flutter run
# 在应用主页找到 "{module_display_name}" 并点击
```

## 代码示例

{code_examples}

## 技术栈

{tech_stack}

## 文件统计

- **总文件数**: {file_count}
- **代码行数**: {line_count:,}
- **页面数**: {page_count}
- **Widget 数**: {widget_count}
- **Model 数**: {model_count}
- **Service 数**: {service_count}

## 依赖项

{dependencies}

## 测试

{tests}

## 相关资源

- [项目主 README](../../README.md)
- [项目简化工作流](../../PROJECT_SIMPLIFICATION_WORKFLOW.md)

## 更新日志

- **{date}**: 初始版本

---

**注意**: 本文档由自动化工具生成，如有错误请手动修正。
"""

def generate_module_structure(module_path, module_name, indent=""):
    """Generate a tree structure representation of the module."""
    structure_lines = []
    items = []

    try:
        items = sorted(os.listdir(module_path))
    except Exception as e:
        print(f"Warning: Could not read {module_path}: {e}")
        return ""

    # Filter out hidden files and common non-essential items
    items = [item for item in items if not item.startswith('.') and item != '__pycache__']

    for i, item in enumerate(items[:10]):  # Limit to first 10 items
        item_path = os.path.join(module_path, item)
        is_last = (i == len(items) - 1) or (i == 9)
        prefix = "└── " if is_last else "├── "

        if os.path.isdir(item_path):
            structure_lines.append(f"{indent}{prefix}{item}/")
            # Add one level of subdirectories
            try:
                subitems = sorted(os.listdir(item_path))
                subitems = [s for s in subitems if not s.startswith('.')][:5]
                for j, subitem in enumerate(subitems):
                    sub_is_last = j == len(subitems) - 1
                    sub_prefix = "    └── " if is_last else "│   └── " if sub_is_last else "│   ├── "
                    if not is_last:
                        sub_prefix = "│   " + ("└── " if sub_is_last else "├── ")
                    structure_lines.append(f"{indent}{sub_prefix}{subitem}")
            except:
                pass
        else:
            structure_lines.append(f"{indent}{prefix}{item}")

    if len(items) > 10:
        structure_lines.append(f"{indent}... and {len(items) - 10} more")

    return "\n".join(structure_lines)

def generate_module_readme(module_name, module_info, lib_path="lib"):
    """Generate README content for a module."""

    module_path = os.path.join(lib_path, module_name)

    # Prepare data
    description = module_info.get('description', '')
    file_count = module_info.get('file_count', 0)
    line_count = module_info.get('line_count', 0)
    pages = module_info.get('pages', [])
    widgets = module_info.get('widgets', [])
    models = module_info.get('models', [])
    services = module_info.get('services', [])
    dependencies = module_info.get('dependencies', [])
    has_tests = module_info.get('has_tests', False)

    # Generate overview
    overview = f"本模块包含 {file_count} 个文件，共 {line_count:,} 行代码。"
    if pages:
        overview += f"提供 {len(pages)} 个页面示例。"

    # Generate features list
    features_list = []
    if pages:
        features_list.append(f"- **{len(pages)} 个示例页面**: " + ", ".join(pages[:3]))
        if len(pages) > 3:
            features_list[-1] += f" 等 {len(pages)} 个页面"

    if widgets:
        features_list.append(f"- **{len(widgets)} 个自定义 Widget**: 可复用的 UI 组件")

    if models:
        features_list.append(f"- **{len(models)} 个数据模型**: 类型安全的数据结构")

    if services:
        features_list.append(f"- **{len(services)} 个服务类**: 业务逻辑封装")

    if not features_list:
        features_list.append("- 完整的功能演示")
        features_list.append("- 清晰的代码组织")
        features_list.append("- 详细的注释说明")

    features = "\n".join(features_list)

    # Generate structure
    structure = generate_module_structure(module_path, module_name)

    # Generate main files list
    main_files_list = []
    if os.path.exists(os.path.join(module_path, 'module_entry.dart')):
        main_files_list.append("- **module_entry.dart**: 模块入口和路由配置")
    elif os.path.exists(os.path.join(module_path, 'module_root.dart')):
        main_files_list.append("- **module_root.dart**: 模块主页面")

    if pages:
        for page in pages[:3]:
            main_files_list.append(f"- **{page}.dart**: {page.replace('_', ' ').title()} 页面")

    main_files = "\n".join(main_files_list) if main_files_list else "- 查看项目结构了解主要文件"

    # Generate code examples
    code_examples = f"""### 基本用法

```dart
// 从主应用导航到此模块
import 'package:go_router/go_router.dart';

// 在任意页面使用
context.push('/{module_name.replace('_', '-')}');
```

### 集成到你的项目

```dart
// 1. 导入模块入口
import 'package:main_app/{module_name}/module_entry.dart';

// 2. 在路由表中注册
// 已在 lib/router/app_route_table.dart 中自动注册
```
"""

    # Generate tech stack
    tech_stack_items = ["- Flutter SDK"]
    if 'provider' in dependencies:
        tech_stack_items.append("- Provider (状态管理)")
    if 'riverpod' in dependencies:
        tech_stack_items.append("- Riverpod (状态管理)")
    if 'bloc' in dependencies:
        tech_stack_items.append("- BLoC (状态管理)")
    if 'dio' in dependencies:
        tech_stack_items.append("- Dio (网络请求)")
    if 'go_router' in dependencies:
        tech_stack_items.append("- GoRouter (路由)")

    tech_stack = "\n".join(tech_stack_items)

    # Generate dependencies section
    if dependencies:
        deps_list = [f"- `{dep}`" for dep in dependencies[:10]]
        if len(dependencies) > 10:
            deps_list.append(f"- ... 和其他 {len(dependencies) - 10} 个依赖")
        dependencies_section = "\n".join(deps_list)
    else:
        dependencies_section = "- 仅依赖 Flutter SDK"

    # Generate tests section
    if has_tests:
        tests_section = """### 运行测试

```bash
flutter test test/{module_name}_test.dart
```

测试已包含在项目中。
"""
    else:
        tests_section = "暂无测试。欢迎贡献测试用例。"

    # Fill template
    readme_content = MODULE_README_TEMPLATE.format(
        module_name=module_name,
        description=description,
        overview=overview,
        features=features,
        structure=structure,
        main_files=main_files,
        module_route=module_name.replace('_', '-'),
        module_display_name=module_name.replace('_', ' ').title(),
        code_examples=code_examples,
        tech_stack=tech_stack,
        file_count=file_count,
        line_count=line_count,
        page_count=len(pages),
        widget_count=len(widgets),
        model_count=len(models),
        service_count=len(services),
        dependencies=dependencies_section,
        tests=tests_section,
        date=datetime.now().strftime("%Y-%m-%d")
    )

    return readme_content

def main():
    # Load module descriptions
    if not os.path.exists('module_descriptions.json'):
        print("Error: module_descriptions.json not found!")
        print("Please run generate_module_descriptions.py first.")
        return

    with open('module_descriptions.json', 'r', encoding='utf-8') as f:
        modules = json.load(f)

    lib_path = "lib" if os.path.exists("lib") else os.path.join(os.getcwd(), "lib")

    print("=" * 70)
    print("Generating Module README Files")
    print("=" * 70)

    generated_count = 0

    for module_name, module_info in modules.items():
        module_path = os.path.join(lib_path, module_name)
        readme_path = os.path.join(module_path, "README.md")

        # Generate README content
        readme_content = generate_module_readme(module_name, module_info, lib_path)

        # Write to file
        try:
            with open(readme_path, 'w', encoding='utf-8') as f:
                f.write(readme_content)
            print(f"✓ Generated: {readme_path}")
            generated_count += 1
        except Exception as e:
            print(f"✗ Error generating {readme_path}: {e}")

    print("\n" + "=" * 70)
    print(f"✓ Generated {generated_count} module README files")
    print("=" * 70)

if __name__ == '__main__':
    main()
