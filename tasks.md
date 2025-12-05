# 📋 Awesome Mail Flutter - 任務追蹤 (Tasks)

## 1. 進行中任務 (In Progress)

### 1.1 同步 UI 整合 (Sync Feedback)
*   **目標**: 讓使用者看見同步狀態與健康度。
*   **Action Items**:
    - [ ] 將 `SyncStatusWidget` (已實作) 整合至首頁 Status Bar 或 Drawer。
    - [ ] 實作同步錯誤/Drift 的 Toast 提示。

### 1.2 搜尋頁面優化 (Search Polish)
*   **目標**: 完善搜尋體驗與篩選 UI。
*   **Status**: Core logic & UI implemented (`SearchPage`, `SearchBloc`).
*   **Action Items**:
    - [ ] 驗證 Filter Chips 的交互細節。
    - [ ] 確認搜尋歷史記錄的持久化體驗。

### 1.3 IAP 支付整合 (Real Backend)
*   **目標**: 將 Mock Stripe 替換為真實支付流程。
*   **Status**: 
    - UI Implemented: `SubscriptionPageImpl`, `PlanComparison`.
    - Backend: `subscriptions.ts` (Currently Mocked Service).
    - Provider: `StripePaymentProvider` (Implemented with `flutter_stripe`).
*   **Action Items**:
    - [ ] **Backend**: 替換 `StripeService` (Mock) 為真實 Stripe SDK 實作。
    - [ ] 註冊 Stripe 帳戶並設定 Webhooks。
    - [ ] 驗證 Platform Pay (Apple/Google Pay) 的整合流程。

## 2. 待辦任務 (Backlog)

### 2.1 Outlook 進階同步 (Incremental Sync)
*   **目標**: 將 Outlook 整合至 `AllMailSyncService`，實現類似 Gmail 的增量同步策略。
*   **現狀**: 
    - `OutlookProvider` 已實作基本的 REST API (`fetchEmails`, `sendEmail`)。
    - 缺乏像 Gmail `historyId` 的高效增量同步與 `AllMailSyncService` 整合。
*   **Action Items**:
    - [ ] 研究 Microsoft Graph API 的 `delta` query 支援。
    - [ ] 擴充 `AllMailSyncService` 以支援 Outlook 策略。

### 2.2 AI 生產環境配置
*   **目標**: 將 AI 服務從開發模式切換至生產環境配置。
*   **現狀**: 後端 `AIServiceFactory` 已支援 OpenAI/Anthropic/OpenRouter。
*   **Action Items**:
    - [ ] 配置真實的 API Keys (OpenAI/Anthropic) 至 Cloudflare Secrets。
    - [ ] 驗證生產環境的 Rate Limits 與 Quota。

### 2.3 後端整合服務 (Integrations)
*   **目標**: 實作後端生產力工具整合 (Notion, Todoist 等)。
*   **現狀**: 
    - Client 端已有 Microsoft/Google/Notion/Todoist 整合。
    - Backend `integrations.ts` 路由與服務尚未實作 (OAuth Redirect handling mostly).
*   **Action Items**:
    - [ ] 建立 `awesome-mail/src/routes/integrations.ts` (for OAuth callback handling).
    - [ ] 實作 Notion/Todoist OAuth 流程與 API Proxy.

### 2.4 技術債與優化
- [ ] **Activate Platform OAuth**: 在 `PlatformOAuthService` 中啟用 `WindowsOAuthService` 與 `WebOAuthService` (目前程式碼存在但被禁用，使用 Fallback Stub)。
- [ ] **Singleton Fixes**: 確認所有全域 Bloc (`MailboxBloc` 等) 註冊為 `@singleton`。

### 2.5 安全功能補完
- [ ] **PGP 真實實作**: 將 `PGPKeyManager` 目前的 Mock (Base64) 邏輯替換為真實 OpenPGP 實作 (`openpgp_dart` 或 native bridge)。

### 2.6 生產力功能補完
- [ ] **Recurring Events**: 實作 `MicrosoftCalendarProvider` 的重複事件支援。
- [ ] **Attendee Management**: 實作 `MicrosoftCalendarProvider` 的參與者管理 (Add/Remove attendees)。

### 2.7 測試擴充
- [ ] **E2E**: 撰寫 Login -> Sync -> AI Summary 完整流程測試。
- [ ] **Perf**: 執行 `scripts/run_desktop_tests.sh` 並建立基準線。
- [ ] **A11y**: 驗證 VoiceOver 導航順序。

## 3. 已完成里程碑 (Completed)
- [x] **Outlook 基礎整合**: `OutlookProvider` 實作完成 (OAuth, Fetch, Send, Folder Ops) via Microsoft Graph API.
- [x] **Protocol Suite**: 
    - `IMAPHandler`: SSL/TLS, Commands, Parsing.
    - `POP3Handler`: USER/PASS, Pagination, Local Search.
    - `SMTPHandler`: AUTH LOGIN, STARTTLS, MIME Composition.
    - `JMAPClient`: Session, Batching, Events, Blobs.
    - `EWSClient`: SOAP, Calendar, Contacts, OOF.
- [x] **Providers**:
    - `YahooProvider`: OAuth + IMAP/SMTP.
    - `ICloudProvider`: App Password + IMAP/SMTP.
    - `ProtonMailProvider`: Bridge Detection, PGP/Web Fallback (Stub).
- [x] **Performance Monitor**: Startup/Transition/API tracking with scoring & suggestions (`PerformanceMonitor`).
- [x] **Backend Jobs**: `JobManager` with Cleanup, UsageReset, HealthCheck jobs.
- [x] **Email Rule Engine**: `EmailRuleEngine` 完整實作 (Conditions, Actions, Evaluation).
- [x] **Batch Operations**: Smart Suggestions & Undo History 實作完成 (`BatchOperationService`).
- [x] **Templates**: Variable Auto-fill & AI Suggestions 實作完成 (`TemplateService`).
- [x] **Platform OAuth Code**: Windows (System Browser) & Web (GIS) OAuth 服務程式碼已實作 (`WindowsOAuthService`, `WebOAuthService`)，待啟用。
- [x] **Microsoft Productivity**: `MicrosoftCalendarProvider` (Core CRUD) 與 `MicrosoftTodoProvider` 實作完成。
- [x] **Adaptive UI**: `AppearanceSettingsPage` 實作完成 (Theme, Density, Layout), `AwesomeOptionPicker` (Platform-aware), `AwesomeTheme` System, `AdaptiveDesignSystem`, `AdaptiveFeedback`.
- [x] **Account Setup**: `AccountSetupPage` 與 Google/Outlook OAuth 流程 (Specific OAuth scopes configured).
- [x] **Secure Account Transfer**: QR Code 裝置轉移功能 (`qr_flutter` integration).
- [x] **核心架構**: Clean Arch, BLoC, DI (Injectable), Global Error Handling (Main.dart), `AppRouter` (Protected Routes).
- [x] **資料庫**: Drift, FTS5 (Emails & Drafts), Indexes, `ai_task_queue` persistence.
- [x] **同步核心**: ALL MAIL Strategy, Incremental Sync (Gmail REST API), Reconciliation, Auto-repair.
- [x] **背景同步**: `BackgroundSyncService` (Isolates), `OfflineQueueService` (Retry logic), Conflict Resolution.
- [x] **AI 核心**: FoundationAIProvider, Dynamic Routing, Task Queue (Persistent), Token Estimator, AI Channel Policy, Session Semaphore.
- [x] **Backend AI Service**: `AIServiceFactory` (OpenAI/Anthropic/OpenRouter), Caching, Usage Tracking (D1).
- [x] **UI 基礎**: Awesome Design System (macOS), 3-pane Layout (Resizable), Text Sanitizer (UTF-16 fix), `AppButton`.
- [x] **Network**: HttpClient (Dio, Interceptors, Retry), ApiClient (Token Refresh, Rate Limit).
- [x] **Accessibility**: `SemanticAnnouncer` (Polite/Assertive announcements).
- [x] **Error Handling**: Global Error Handler (Main.dart), Overflow Debugger, Isolate Error Reporting.
- [x] **AI Infrastructure**: Token Estimator (CJK/Non-CJK), Foundation Models Framework, AI Init Coordinator.
- [x] **UI 進階**: AI Drawer (Classification/Summary/Chat), Message Banner (Security), Composer (Rich Text), To-Do List.
- [x] **Reading Experience**: AwesomeReadingPane (Conversation/Single), EmailSummaryPanel, MessageBanner.
- [x] **Settings (macOS)**: `MacOSSettingsWidgets` 實作.
- [x] **Backend Subscription**: Subscriptions API, Plans, Mock Stripe Service, Webhook Endpoint.
- [x] **Backend Auth**: OAuth Link/Unlink, Refresh Tokens, User Devices.
- [x] **Security**: `SecurityService`, `SimpleSecurityAnalyzer` (Local Heuristics), Anti-phishing (Spoofing/Urgency), Sender Auth (SPF/DKIM/DMARC), `BiometricService`.
- [x] **Help System**: `AwesomeHelpSystem` (Getting Started, Shortcuts, FAQ).
- [x] **Automation**: Rule Engine (RegEx, Webhook, Notifications), Visual Rule Builder, Templates.
- [x] **Settings Backup**: Export/Import JSON, Versioning, `file_picker` & `share_plus` integration.
- [x] **Metrics**: Frontend Service & Backend Durable Object Proxy, `UsageTrackingService` (Quota).
- [x] **Productivity Tools**: Command Palette (Fuzzy Search, Categories, Shortcuts), Attachment Viewer, Drag & Drop Controller.
- [x] **Infrastructure**: Biometric Auth, Network Info, Theme Manager, Email Cache (Multi-layer), Splash Screen, Unread Count Manager.
- [x] **Enterprise**: Productivity Service (Calendar/Tasks), Remote Config, App Update Service, Backend Logging.
- [x] **Diagnostics**: AI Diagnostics Page (Plugin/Client lifecycle events), Overflow Debugger, `AIModelStatusChip`.
- [x] **Accessibility**: `AccessibilityService` (Semantic announcements, screen reader integration).
- [x] **Platform Integration**: Writing Tools (Apple Intelligence), App Intents (Shortcuts), Menu Service (macOS Native).
- [x] **Telemetry**: SyncMetricsCollector (Real-time, Quota Tracking), SyncHealthChecker (Auto-Repair).
- [x] **AI Tools**: SecuritySignalsTool, QuotaTool, UrlReputationTool.
- [x] **Telemetry**: SyncMetricsCollector (Real-time, Quota Tracking), SyncHealthChecker (Auto-Repair).
- [x] **AI Tools**: SecuritySignalsTool, QuotaTool, UrlReputationTool.
- [x] **Sync State**: SyncStateManager (SSOT, Concurrency Locking), Offline Queue, Background Sync Service.
- [x] **Extensions**: Plugin Registry, Shortcut Actions, Localization (en, zh, ja via .arb).
- [x] **Dev Ops**: Scripts for testing, deployment, and keychain fixes.
- [x] **Search**: FTS5, SearchCache, SearchQueryParser (Advanced Syntax).
- [x] **AI Framework**: Foundation Models Framework, AI Init Coordinator (Event-driven Retry), AI Dashboard, Guided Engines (Summary/Reply).
- [x] **Google Productivity**: Calendar (Recurring Events, Reminders) & Tasks providers implemented.
- [x] **Apple Integration**: Apple Reminders (CalDAV), Writing Tools, App Intents.
- [x] **UI Enhancements**: Conversation View (Threading, Shortcuts), Command Palette, Memory Monitor, Adaptive Feedback.
- [x] **Database Indexes**: Implemented optimized composite indexes (`idx_emails_account_unread_received`, `idx_emails_has_full_content` etc.) for high-performance queries.
- [x] **Network Monitor**: Bandwidth calculation, connectivity history, and optimization suggestions.
- [x] **FTS5 Triggers**: Implemented auto-sync triggers for FTS tables (`emails_fts`, `drafts_fts`).
- [x] **Biometric Strength**: Implemented `BiometricService` with strength check and preference management.
- [x] **Developer Tools**: Complex Email Test Page, Layout Debugging (OverflowDebugger), WebView Test, `DebugStorage`.
- [x] **Smart Prefetch**: FullContentDownloadService (Background Content Prefetch).
- [x] **Sync Telemetry**: SyncMetricsCollector (Detailed Sync Metrics).
- [x] **Shortcuts**: Keyboard Shortcuts (Gmail-style, Batch Actions) implemented (`AwesomeKeyboardShortcuts`).
- [x] **Monitoring**: Performance, Memory, and Network monitors (`MemoryMonitor`, `NetworkMonitor` w/ Native Channels).
- [x] **Productivity**: Calendar/Task aggregation (`ProductivityService`, `GoogleCalendarProvider`, `GoogleTasksProvider`, `EWSClient`, `CalDavClient`, `CardDavClient`) and Conflict Detection.
- [x] **Templates**: CRUD, Variable Auto-fill (AI-powered), Context Suggestions (`TemplateService`).
- [x] **Drafts**: Auto-save (30s), Reply/Forward format conversion, Cache integration (`DraftService`).
- [x] **Plugins**: `PluginRegistry` and `PluginInterface` architecture implemented.
- [x] **Remote Config**: Feature Flags, Experiments, Maintenance Mode, API Endpoints (`RemoteConfigService`).
- [x] **Updates**: Cross-platform update check logic (`UpdateService`).
- [x] **Editor**: Rich Text Editor (Quill) with AI integration (`RichTextEditor`), Attachment handling (25MB limit), `AIWritingAssistant`.
- [x] **AI Features**: Recursive Summarization, Newsletter Digest/Cleaner, Guided Sessions (JSON).
- [x] **Command Palette**: `AwesomeCommandPalette` with category filtering and keyboard navigation.
- [x] **Lifecycle Management**: `AppLifecycleManager` with background activity tracking and resume sync trigger.
- [x] **Secure Storage**: `DeviceIdService` & `StatePersistenceService` with macOS keychain error handling.
- [x] **Onboarding**: OAuth Feature Discovery Widget.
- [x] **Biometric Auth**: `BiometricSetupPage` and `BiometricService`.
- [x] **Error Handling**: `AwesomeMailException` hierarchy & `HttpClient` interceptors.
- [x] **Visual Progress**: `DownloadProgressCubit` for full content download tracking.
- [x] **Unified OAuth**: `UnifiedOAuthService` & `OAuthErrorReporter`.
- [x] **Integration Tests**: Core suite (`auth`, `database`, `security`, `ai`).
- [x] **Webview Integration**: `url_launcher` for external links in `EmailMinimalWebView`.
- [x] **CI/CD**: GitHub Actions Workflows (Build, Test, Coverage).
- [x] **Payment Service**: Stripe/Apple/Google Pay wrapper (`PaymentService`, `StripePaymentProvider`).
- [x] **Batch Operations**: `BatchOperationsPage` with suggestions and undo history.
- [x] **Authentication**: `AuthService` (Login, Register, Refresh Token, Logout).
- [x] **Animation & Performance**: `AwesomeAnimationController`, `VirtualizedList`, `ImageCache`.
