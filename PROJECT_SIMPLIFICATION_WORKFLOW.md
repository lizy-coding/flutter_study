# 项目简化工作流

> 创建日期: 2025-12-28
> 目的: 清理冗余文档、配置文件，简化项目结构

## 工作流概览

本工作流分为 4 个阶段，逐步清理和简化项目：

- **阶段 1**: 清理已完成的迁移文档 ✅
- **阶段 2**: 合并配置文件，删除冗余路由 ✅
- **阶段 3**: 代码重构 - 拆分大文件 🔧
- **阶段 4**: 验证和测试 ✅

---

## 阶段 1: 清理迁移文档

### 目标
删除或归档已完成的迁移相关文档（M1-M3 已完成）

### 操作清单

#### 1.1 删除迁移文档 (3个文件)

| 文件 | 大小 | 原因 | 操作 |
|------|------|------|------|
| `MIGRATION_PLAN.md` | 4.0K | 迁移计划已完成 75%，M1-M3 已执行 | **删除** |
| `MIGRATION_MILESTONE_WORKFLOW.md` | 4.0K | 里程碑工作流记录，历史文档 | **删除** |
| `PHASE2_EXECUTION_RULES.md` | 1.7K | 执行规则，迁移完成后不再需要 | **删除** |

**命令：**
```bash
rm MIGRATION_PLAN.md
rm MIGRATION_MILESTONE_WORKFLOW.md
rm PHASE2_EXECUTION_RULES.md
```

#### 1.2 删除迁移脚本

| 文件 | 原因 | 操作 |
|------|------|------|
| `migrate_core_to_main_app_lib.sh` | 迁移已完成，脚本不再使用 | **删除** |

**命令：**
```bash
rm migrate_core_to_main_app_lib.sh
```

**预期结果：**
- 减少 4 个文件，约 10KB
- 保留 `README.md` 作为项目唯一主文档

---

## 阶段 2: 合并配置文件和删除冗余路由

### 目标
合并分散的配置文件，删除与统一路由表重复的代码

### 操作清单

#### 2.1 合并 .gitignore 文件

**当前状态：**
- 根目录: `.gitignore` (118行，完整规则)
- Windows 目录: `windows/.gitignore` (18行，仅 Windows 规则)

**操作步骤：**
1. 读取 `windows/.gitignore` 内容
2. 将 Windows 特定规则追加到根 `.gitignore` 的 `# Windows` 部分
3. 删除 `windows/.gitignore`

**命令：**
```bash
# 1. 备份根 .gitignore
cp .gitignore .gitignore.backup

# 2. 查看 windows/.gitignore 内容
cat windows/.gitignore

# 3. 手动合并后删除
rm windows/.gitignore
```

**预期结果：**
- 只保留 1 个 `.gitignore` 文件
- Windows 规则已合并到根文件

#### 2.2 删除冗余路由文件

**问题分析：**
- 统一路由表: `lib/router/app_route_table.dart` (282行，全局路由)
- 冗余文件 1: `lib/status_manage/app/app_routes.dart` (内部路由表)
- 冗余文件 2: `lib/tree_state/routes.dart` (路由常量定义)

**操作步骤：**
1. 确认 `app_route_table.dart` 已包含这些路由
2. 删除冗余路由文件
3. 更新引用这些文件的代码

**命令：**
```bash
# 1. 确认路由定义
grep -r "status_manage" lib/router/app_route_table.dart
grep -r "tree_state" lib/router/app_route_table.dart

# 2. 查找引用
grep -r "app_routes.dart" lib/
grep -r "routes.dart" lib/tree_state/

# 3. 删除文件（先备份）
cp lib/status_manage/app/app_routes.dart lib/status_manage/app/app_routes.dart.backup
cp lib/tree_state/routes.dart lib/tree_state/routes.dart.backup
rm lib/status_manage/app/app_routes.dart
rm lib/tree_state/routes.dart
```

**需要更新的文件：**
- `lib/status_manage/` 下引用 `app_routes.dart` 的文件
- `lib/tree_state/` 下引用 `routes.dart` 的文件

**预期结果：**
- 删除 2 个冗余路由文件
- 所有路由统一在 `app_route_table.dart` 中管理

---

## 阶段 3: 代码重构 - 拆分大文件

### 目标
拆分超过 500 行的文件，提高代码可维护性

### 操作清单

#### 3.1 拆分 pop_widget/module_root.dart (895行)

**问题：**
- 单文件包含所有弹窗示例
- 缺乏模块化

**重构方案：**
```
lib/pop_widget/
├── module_root.dart              # 主入口 (保留，但简化为路由页)
├── widgets/
│   ├── dialog_examples.dart      # 对话框示例
│   ├── bottom_sheet_examples.dart # 底部表单示例
│   ├── menu_examples.dart        # 菜单示例
│   └── snackbar_examples.dart    # Snackbar 示例
└── pages/
    └── pop_widget_demo_page.dart # 演示页面
```

**预期结果：**
- 拆分为 5-6 个文件，每个 150-200 行
- 代码按功能分类

#### 3.2 拆分 download_animation_demo 大文件 (3个文件 >500行)

**问题：**
- `paint_animation_page.dart` (617行)
- `download_comparison_page.dart` (599行)
- `download_animation_page.dart` (515行)

**重构方案：**
```
lib/download_animation_demo/
├── pages/
│   ├── paint_animation_page.dart      # 主页 (简化为 200行)
│   ├── download_comparison_page.dart  # 主页 (简化为 200行)
│   └── download_animation_page.dart   # 主页 (简化为 200行)
├── widgets/
│   ├── paint_animation_widget.dart    # CustomPaint 组件
│   ├── comparison_widget.dart         # 对比组件
│   ├── download_button.dart           # 下载按钮
│   └── animation_controller_panel.dart # 控制面板
└── painters/
    └── download_painter.dart          # 自定义绘制
```

**预期结果：**
- 每个 page 文件 <300 行
- 组件可复用

#### 3.3 拆分其他大文件 (可选)

| 文件 | 行数 | 优先级 | 建议 |
|------|------|--------|------|
| `debounce_throttle/module_root.dart` | 610 | 低 | 提取组件到 widgets/ |
| `interceptor_test/mock_server/mock_server.dart` | 498 | 低 | 保持当前结构 (完整 Mock) |
| `microtask/.../advanced_examples_page.dart` | 417 | 低 | 提取示例到独立文件 |

**预期结果：**
- 项目无超过 500 行的单文件
- 平均文件大小 <300 行

---

## 阶段 4: 验证和测试

### 目标
确保简化后项目能正常运行

### 操作清单

#### 4.1 静态分析

```bash
flutter analyze
```

**期望输出：**
```
Analyzing flutter_study...
No issues found!
```

#### 4.2 编译测试

```bash
flutter build apk --debug
```

**期望结果：**
- 编译成功，无错误

#### 4.3 功能测试

**测试清单：**
- [ ] 主页能正常显示所有模块列表
- [ ] 点击各模块能正常跳转
- [ ] 删除的路由文件不影响导航
- [ ] pop_widget 模块能正常展示
- [ ] download_animation_demo 能正常运行

#### 4.4 Git 提交

```bash
# 1. 查看更改
git status
git diff

# 2. 添加更改
git add .

# 3. 提交
git commit -m "chore: 项目简化 - 清理冗余文档和配置

- 删除迁移相关文档（MIGRATION_PLAN.md 等3个文件）
- 删除迁移脚本 migrate_core_to_main_app_lib.sh
- 合并 windows/.gitignore 到根 .gitignore
- 删除冗余路由文件（status_manage/app_routes.dart, tree_state/routes.dart）
- 拆分大文件 pop_widget/module_root.dart (895行 → 5个文件)
- 拆分 download_animation_demo 大文件 (3个 >500行 → 10个文件)

简化结果:
- 减少文档文件: 4个 (~10KB)
- 减少配置文件: 1个
- 减少冗余代码文件: 2个
- 代码重构: 4个大文件拆分为多个小文件
- 代码可维护性提升"

# 4. 推送 (可选)
git push origin dev
```

---

## 执行规则

### 安全原则
1. **先备份再删除** - 所有删除操作前先备份
2. **逐步验证** - 每个阶段完成后运行 `flutter analyze`
3. **保留 README.md** - 项目主文档必须保留

### 执行顺序
1. 必须按照 阶段 1 → 阶段 2 → 阶段 3 → 阶段 4 顺序执行
2. 每个阶段完成后验证再继续
3. 发现问题立即回滚

### 回滚策略
```bash
# 如果出现问题，恢复备份
git checkout .
git clean -fd

# 或使用备份文件
cp .gitignore.backup .gitignore
cp lib/status_manage/app/app_routes.dart.backup lib/status_manage/app/app_routes.dart
```

---

## 预期收益

### 文件清理
- **删除文件数**: 7个 (4个文档 + 1个脚本 + 2个冗余路由)
- **减少代码量**: ~500 行 (冗余路由代码)
- **配置统一**: 1 个 .gitignore

### 代码质量提升
- **最大文件行数**: 895 行 → <300 行
- **文件平均大小**: ~860 行 → ~250 行
- **代码可维护性**: ⭐⭐⭐ → ⭐⭐⭐⭐⭐

### 项目结构优化
- **文档集中**: 只保留 1 个 README.md
- **路由统一**: 所有路由在 app_route_table.dart
- **模块化**: 大文件拆分为多个小文件

---

## 检查清单

### 阶段 1 完成检查
- [ ] 删除 `MIGRATION_PLAN.md`
- [ ] 删除 `MIGRATION_MILESTONE_WORKFLOW.md`
- [ ] 删除 `PHASE2_EXECUTION_RULES.md`
- [ ] 删除 `migrate_core_to_main_app_lib.sh`
- [ ] 运行 `flutter analyze` 无错误

### 阶段 2 完成检查
- [ ] 合并 `windows/.gitignore` 到根 `.gitignore`
- [ ] 删除 `windows/.gitignore`
- [ ] 删除 `lib/status_manage/app/app_routes.dart`
- [ ] 删除 `lib/tree_state/routes.dart`
- [ ] 更新引用这些文件的代码
- [ ] 运行 `flutter analyze` 无错误

### 阶段 3 完成检查
- [ ] 拆分 `pop_widget/module_root.dart`
- [ ] 拆分 `download_animation_demo` 3个大文件
- [ ] 更新 import 引用
- [ ] 运行 `flutter analyze` 无错误

### 阶段 4 完成检查
- [ ] `flutter analyze` 通过
- [ ] `flutter build apk --debug` 成功
- [ ] 主页显示正常
- [ ] 各模块跳转正常
- [ ] Git 提交完成

---

## 附录

### A. 项目简化前后对比

| 指标 | 简化前 | 简化后 | 变化 |
|------|--------|--------|------|
| Markdown 文档数 | 4 | 1 | -3 |
| .gitignore 文件 | 2 | 1 | -1 |
| 路由配置文件 | 3 | 1 | -2 |
| 最大文件行数 | 895 | <300 | -595 |
| 平均文件行数 | ~860 | ~250 | -610 |
| 超过 500 行文件数 | 8 | 0 | -8 |

### B. 保留的文件清单

**文档：**
- `README.md` - 项目主文档

**配置：**
- `.gitignore` - Git 忽略规则 (合并后)
- `pubspec.yaml` - 依赖配置
- `analysis_options.yaml` - Dart 分析选项
- `main_app.iml` - IDE 配置

**路由：**
- `lib/router/app_route_table.dart` - 统一路由表 (282行)

### C. 相关命令参考

```bash
# 查看文件大小
ls -lh *.md

# 统计代码行数
find lib -name "*.dart" -exec wc -l {} + | sort -n

# 查找大文件
find lib -name "*.dart" -exec wc -l {} + | sort -rn | head -10

# 查找引用
grep -r "app_routes" lib/
grep -r "import.*routes" lib/

# Git 操作
git status
git diff
git add .
git commit -m "message"
git push origin dev
```

---

**创建人**: Claude
**最后更新**: 2025-12-28
**状态**: 待用户确认
**下一步**: 用户确认后执行阶段 1
