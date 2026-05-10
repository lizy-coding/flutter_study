# 整改计划

> 项目重构与代码质量提升计划。优先级从高到低排列。

## Phase 1 — 目录结构重构 ✅

**目标**: 从扁平 `lib/<module>/` 改为 `app/ + module_registry/ + shared/ + modules/<category>/` 层级。

**已完成**:
- [x] `app.dart` → `app/app.dart`
- [x] `router/` → `app/router/`
- [x] 新建 `module_registry/`，拆分 ModuleEntry 模型和枚举
- [x] 按 basic/async/state/ui/platform 分类迁移所有 15 个模块
- [x] 清理目录名（去掉 `_demo`/`_test` 后缀）
- [x] 更新所有 import 路径和文档

## Phase 2 — 模块内部规范化 ⏳

**目标**: 逐步统一模块内部分层（presentation/application/domain/data）。

- [ ] `popup_widgets` — 拆分 895 行 `module_root.dart` 为独立页面
- [ ] `debounce_throttle` — 迁移为 `module_entry + module_root + utils` 精简模式
- [ ] `status_management` — 保持 app/features/shared 分层，添加测试
- [ ] 所有模块补齐 `AI_ANALYSIS.md`（如有缺失）

## Phase 3 — 测试与质量 🔲

**目标**: 提升测试覆盖率和代码质量。

- [ ] 为无测试模块补充基础 Widget 测试
- [ ] 引入 lint 规则增强（如 `prefer_const_constructors`）
- [ ] `scroll_table` 和 `usb_detector` — 从 `ModuleStatus.pending` 提升到 `ready`

## Phase 4 — 教学体验 🔲

**目标**: 更多模块使用教学模板（`LearningScaffold`）。

- [ ] `adsorption_line` — 改造为教学页面
- [ ] `stream_subscription` — 改造为教学页面
- [ ] `download_animation` — 改造为教学页面
