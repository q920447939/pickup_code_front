# 技术文档

## 基础信息
开发语言: Flutter
语言版本: Flutter 3.38.5（Dart 版本随 Flutter SDK）
目标平台: Android, iOS
Android 最低版本: Android 13（API 33 / minSdkVersion=33）
适配策略: Android 优先；iOS 功能按平台限制做降级实现（平台边界见 PRD）

## 技术选型（客户端）
状态管理: GetX（Controller + Rx/Obx）
路由导航: GetX（GetMaterialApp + 命名路由 + Bindings）
依赖注入: GetX（Bindings + Get.put/Get.lazyPut）
屏幕自适应: flutter_screenutil（必须）
本地存储: drift + SQLite（sqlite3_flutter_libs）
权限管理: permission_handler
本地通知/提醒: flutter_local_notifications + timezone
桌面小组件: home_widget（优先）
网络库（AI 模式预留）: dio（离线模式不初始化/不发起任何网络请求）

## 工程与代码规范（建议强制）
- 目录结构
  - `lib/app/`: 路由、主题、全局配置、通用组件/工具
  - `lib/modules/`: 业务模块（pickup/templates/settings/mode/ai(占位)/group(占位)）
  - `lib/domain/`: 实体、用例（usecase）、仓库接口（Repository contracts）
  - `lib/data/`: drift 数据库、DAO、Repository 实现、平台通道、DTO/映射
- GetX 约定
  - 每个页面/模块对应 1 个 Controller；页面只负责渲染与事件转发
  - 使用 Bindings 注入依赖；禁止在 Widget build 内做 Get.put
  - 列表拆分组件，避免单个 Obx 包大树造成全量 rebuild
- ScreenUtil 约定
  - 全局初始化: `ScreenUtilInit(designSize: Size(375, 812), minTextAdapt: true, splitScreenMode: true, ...)`
  - 尺寸统一使用 `.w/.h/.sp/.r`；禁止硬编码 px

## 平台能力与实现策略

### Android（P0）
- 短信接入: Kotlin + Platform Channel（MethodChannel/EventChannel）
  - BroadcastReceiver 监听 `SMS_RECEIVED` 获取短信正文
  - 进入 Flutter 后调用“本地识别引擎”解析并入库
  - 去重策略：同一短信/同一取件码短窗口内避免重复入库
- 通知权限: Android 13+ 需要运行时申请 `POST_NOTIFICATIONS`
- 省电策略: 不做高频后台轮询；提醒仅在“数据变更”时重排程
- 悬浮窗: 可选高级功能（高敏权限），默认关闭

### iOS（P0）
- 短信限制: 无法后台自动读取/监听短信
  - 替代方案: 粘贴导入/手动补录触发识别
- Widget: iOS WidgetKit 通过 home_widget 或原生桥接实现待取摘要展示

## 关键模块技术说明
- 识别引擎（离线/AI 通用）
  - 本地规则: 关键词 + 正则模板
  - 用户模板: 通过“示例文本→提取槽位（code/station/expire）→生成规则→测试→启用”
  - 统一输出: `PickupParseResult`（字段 + 命中规则 + 置信度），用于 UI 预览与纠错
- 本地提醒
  - 调度策略: inexact；不追求秒级准确
  - 触发点: 新增/编辑/删除/标记已取时统一重排程
  - 过期状态: 优先在查询/展示时按当前时间即时计算（必要时在 App 回到前台时轻量刷新）
- 模式隔离
  - 离线/AI 数据域隔离（分库或逻辑隔离均可，但必须“不会串数据”）
  - 离线模式: 禁止任何网络请求（代码层面隔离；不初始化 dio/远程数据源）

## AI 模式（仅客户端位点，暂不包含后端）
- 预留接口（domain）
  - `AiExtractApi`: 文本片段 -> 结构化字段（取件码/驿站/到期）
  - `GroupSyncApi`: 小组/代取记录同步（后续接入）
- data 层提供 Fake 实现用于联调 UI 与流程；后续接入真实后端时仅替换 data 层实现
