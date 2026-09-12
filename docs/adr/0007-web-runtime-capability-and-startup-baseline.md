# Web 运行能力与启动体验基线

状态：accepted。Flutter Forge 的 Web 文件选择只承诺由使用者选择单个文件并展示文件名，不把临时 `blob:` URL 当作本地路径或内容合同；在线视频验收使用项目控制、支持 HTTPS/CORS/Range 的同源媒体资源，不以公共测试地址作为交付依据。Web Release 将渲染资源同源部署，不依赖 `gstatic.com`，在没有离线产品需求时不启用 Flutter Service Worker，并由静态宿主 loading shell 覆盖 Flutter 首帧前的等待与十秒失败重载。首版先测量并优化资源链路，只有冷启动仍不达标时才拆分目录元数据与模块执行入口，避免过早重构中央路由生成器。

## Consequences

- Safari 与 Chrome 是必测浏览器，Edge 执行冒烟验证，Firefox 当前不阻塞交付。
- Loading 必须在 Flutter 首帧后移除，并记录脚本加载、引擎初始化和首帧阶段，不能用无限动画隐藏失败。
- 同源测试视频不参与首屏预加载；公共媒体地址只用于辅助诊断。
- Web 文件选择默认允许任意单文件；原生端可继续保留扩展过滤教学。
