# 🎨 Awesome Mail Flutter - 設計規範 (Design)

## 1. 系統架構與原則

本專案採用 Clean Architecture 與 BLoC 狀態管理模式，並強調「平台適應 (Adaptive)」、「隱私優先 (Privacy-First)」與「高效能 (High Performance)」。

### 1.1 核心設計理念
*   **平台適應 (Adaptive)**:
    *   **桌面端 (macOS)**: Native Look & Feel (Cupertino)，高密度排版，滑鼠/鍵盤優化。
    *   **行動端 (iOS/Android)**: 觸控優先，符合 iOS Human Interface & Material Design 3。
    *   **策略**: **智慧元件層 (Smart Component Layer)** — 邏輯共用，視圖分流。
    *   **實作**: `AdaptiveWidgets` 與 `AwesomeOptionPicker` 自動適配 Popup Surface (macOS) 與 Action Sheet (iOS)。
    *   **反饋**: `AdaptiveFeedback` 根據平台選擇 SnackBar (Mobile) 或 CupertinoDialog (Desktop)。
    *   **導航 (Routing)**: `AppRouter` 整合 BLoC 權限控管 (`AuthBloc`)，並根據平台自動切換首頁 (`MacOSHomePage` vs `HomePage`)。注意：`HomePage` 已被標記為 Deprecated，未來將統一由 `MacOSHomePage` (或其 Adaptive 版本) 取代。目前部分路由 (如 `emailList`) 使用 Placeholder 頁面過渡。
    *   **原生通道 (Native Channels)**: 使用 `MethodChannel` 整合原生功能 (`awesome_mail/menu`, `awesome_mail/memory`, `awesome_mail/oauth`, `awesome_mail/writing_tools`, `awesome_mail/app_intents`)。
*   **隱私優先**: AI 運算皆在本地 (On-Device) 執行；OAuth Token 採用 Vault 結構儲存。
*   **Database-First**: UI 優先從本地資料庫讀取，背景非同步更新，確保即時響應。
*   **Remote Config**: `RemoteConfigService` 提供動態配置 (API URL, Feature Flags)，支援 ETag 快取與 Periodic Fetch (1hr)。
*   **Account Repository**: 採用 **On-the-Fly Hydration** 策略。`AccountConfig` 在資料庫中僅儲存非敏感設定，OAuth Token 等敏感憑證由 `CredentialManager` 在讀取時動態注入，確保靜態資料安全。
*   **IAP Architecture**:
    *   **Frontend**: `InAppPurchaseService` (Store) / `PaymentService` (Stripe/Platform Pay).
    *   **Backend**: `/subscriptions/*` 端點處理 Stripe Webhook (`invoice.payment_succeeded` 等)，更新 `subscriptions` 與 `payments` 表。目前提供 `StripeService` Mock 實作以便開發。
*   **Plugin Architecture**:
    *   `PluginRegistry`: 管理插件註冊、驗證與生命週期。
    *   `PluginManager`: 提供統一介面供應用程式調用各類型插件 (Email, UI, AI, Automation)。
*   **Environment-Aware**: 透過 `EnvironmentConfig` 與 `AwesomeMailConfig` 支援多環境 (Dev/Staging/Prod) 切換與功能開關 (Feature Flags)。
*   **Global Error Handling**: `_setupGlobalErrorHandling` (Main.dart) 攔截 Flutter Framework, Isolate, Platform 錯誤，並整合 `OverflowDebugger` 進行佈局診斷。
*   **Lifecycle Management**: `AppLifecycleManager` 負責監聽 `WidgetsBindingObserver`，管理背景計時器與資源釋放 (Detached state)。

### 1.2 依賴注入與生命週期 (Dependency Injection)
為確保全域狀態一致性，關鍵 BLoC/Cubit 必須採用單例模式：
*   **@singleton**: `MailboxBloc` (郵箱狀態), `AppBloc` (App生命週期), `SettingsBloc`, `AuthBloc`, `SyncBloc`.
*   **@lazySingleton**: `AccountCubit` (帳號管理), `FolderCubit` (資料夾管理), `EmailSyncCubit` (週期同步).
*   **@injectable (Factory)**: `ComposeBloc` (多視窗撰寫), `AccountSetupBloc` (獨立流程), `DownloadProgressCubit` (下載狀態), `SearchBloc`.
*   **Separation of Concerns**: `MailboxBloc` 已重構，將帳號列表管理拆分至 `AccountCubit`，資料夾列表管理拆分至 `FolderCubit`，週期同步邏輯拆分至 `EmailSyncCubit`，降低單一 BLoC 複雜度。
*   **Mechanics**: 使用 `get_it` 與 `injectable` 進行管理，支援環境變數注入 (e.g., `backendBaseUrl`). `CoreModule` 負責註冊 Dio, SecureStorage, PackageInfo 等基礎服務。
*   **Network Layer**: `HttpClient` (Dio wrapper) 提供統一的 Error Handling, Interceptors 與 Retry Logic (Exponential Backoff, Max 3 retries). `ApiClient` 處理高階 API 邏輯如 Token Refresh Retry.

## 2. UI 設計系統 (Awesome Design System)

### 2.1 Design Tokens
*   **檔案**: `lib/shared/themes/macos_design_system.dart` (macOS), `awesome_design_system.dart` (Shared).
*   **色彩**: `AwesomeColors`支援動態取色 (Light/Dark).
*   **排版**: `MacOSTypography` (SF Pro 風格)。
*   **動畫**: `AwesomeAnimation` (Fast: 150ms, Normal: 250ms)，`AwesomeTransitionBuilder` 支援頁面轉場。
*   **擴充 (Theme Extension)**: `AwesomeThemeExtension` 提供特定語義顏色 (Sidebar, Chip, Security)，支援 `AwesomeThemeBuilder` 統一建構。
*   **Responsive Extensions**: `AwesomeResponsiveExtensions` 提供 `awesomeSidebarWidth`, `awesomeAIDrawerWidth` 等動態尺寸計算，支援 1/2/3 欄佈局自動切換。
*   **Responsive Utils**: `ResponsiveLayout`, `ResponsiveHelper`, `ResponsiveGrid` 提供統一的斷點管理與佈局策略。
*   **Adaptive Design System**: `AdaptiveDesignSystem` 類別統一管理跨平台的 Colors, Typography, Spacing 與 Dimensions，自動適配 Desktop/Mobile。

### 2.2 關鍵組件
*   **macOS 原生增強**: `MacOSWindow` (交通燈, 標題列), `MacOSSidebar` (收折, 徽章), `MacOSEnhancedToolbar`.
    *   **Home Structure**: `MacOSHomePage` 採用標準三欄式佈局 (Sidebar, Mail List, Reading Pane)，並整合 `AwesomeAIDrawer` (右側滑出) 與 `AwesomeComposeDrawer` (底部滑出)。
*   **Resizable Layouts**: `ResizableTwoColumnLayout` 與 `ResizableThreeColumnLayout` 提供可拖曳調整的響應式佈局，支援寬度持久化 (SharedPreferences).
*   **Accessibility**: `SemanticAnnouncer` 提供統一的語音播報介面，支援 `AnnouncementPriority` 控制打斷行為。
*   **適配層**: `AdaptiveWidgets` 工廠 (自動切換 MacOS/Material 實作).
*   **列表虛擬化**: `EmailListWidget` 支援 >1000 項目高效渲染。
    *   **VirtualizedList**: 自定義的高效能列表組件 (`VirtualizedList<T>`)，僅渲染視窗可見範圍內的項目 (Viewport + Buffer)，採用 `Stack` + `Positioned` 絕對定位而非標準 `ListView`，優化大量複雜 Item 的渲染效能。
    *   **EmailListItem**: 支援滑動操作 (Swipe Actions) 與拖曳 (Drag & Drop)。
*   **Reading Pane**: `AwesomeReadingPane` 提供單一/對話串檢視切換，整合 `MessageHeader`, `MessageBanner` (Security/Images), `EmailSummaryPanel` (AI), `MessageContent` (WebView/Attachments).
    *   **Security Integration**: `SecurityAnalysisPanel` 提供多頁籤詳細報告 (Overview/Phishing/Links/Privacy)，包含 SPF/DKIM/DMARC 驗證狀態與可疑連結列表。
*   **AI 面板**: `AwesomeAIDrawer` (右側滑出)，含摘要/回覆建議/對話分頁。`EmailClassificationWidget` 提供視覺化的分類信心與情感指標。
    *   **AI Assistant**: `AIConversation` 提供即時的自然語言郵件助理介面。
*   **鍵盤導航**: `AwesomeKeyboardShortcuts` 支援 Gmail 風格快捷鍵 (j, k, c, e, #, /, etc.) 與批次操作快捷鍵。
*   **Rich Text Editor**: 基於 `flutter_quill` 封裝的 `RichTextEditor`，整合 AI 寫作輔助與附件管理 (Max 25MB)。
    *   **AI Writing Assistant**: `AIWritingAssistant` Dialog 提供風格分析與建議生成。
    *   **Attachment Panel**: `AttachmentPanel` 管理附件列表。
*   **Message Banner**: `MessageBanner` 與 `SecurityMessageBanners` 提供統一的狀態與安全警示 UI。
*   **Theme System**: `ThemeManager` 統一管理主題生成。
    *   **Platform-Aware**: `getTheme` 自動根據平台 (`TargetPlatform.macOS`) 切換使用 `MacOSThemeBuilder` (Native Look) 或 `_getStandardTheme` (Material 3)。
    *   **Awesome Styling**: 支援 `AwesomeThemeBuilder` 產生專屬的 Awesome Mail 風格 (高對比、閱讀優化配色)。
*   **App Button**: `AppButton` 提供統一的按鈕樣式封裝。
*   **Contacts Integration**: `ComposeBloc` 具備處理收件人 (To/Cc/Bcc) 變更的邏輯，預留了與 `ContactRepository` (未來實作) 整合的介面。
*   **Feature Discovery**: `OAuthFeatureDiscoveryWidget` 提供新功能引導動畫。
*   **Migration UI**: `OAuthMigrationWidget` 提供分步驟的帳號遷移介面，包含進度指示器與錯誤處理。
*   **Platform Integrations**:
    *   **URL Launcher**: `EmailMinimalWebView` 使用 `url_launcher` 攔截並開啟外部連結。
    *   **File Picker**: `BackupSettingsPage` 使用 `file_picker` 匯入設定檔。
    *   **Share Plus**: `BackupSettingsPage` 與 `QRGeneratorPage` 使用 `share_plus` 分享檔案與連結。
    *   **App Intents**: `AppIntentService` 透過 `awesome_mail/app_intents` 通道支援 `summarizeMail` 與 `explainRisk` 原生捷徑指令。
    *   **Native Menu**: `MenuService` 透過 `awesome_mail/menu` 通道處理 macOS 選單動作 (File, Edit, View, Email, Account, Tools, Help)。
    *   **Email Rendering**: `EmailMinimalWebView` 使用 `flutter_inappwebview` 實作極簡渲染。
        *   **JS Bridge**: 透過 `callHandler('webviewClick')` 與 `callHandler('openLink')` 攔截點擊與連結，由 Flutter 統一處理導航與互動，繞過 WebView 內部導航。
        *   **MacOS Scroll**: 注入自定義 JS (`window.flutterScrollBy`) 實現平滑的觸控板滾動體驗。
*   **Batch Operations**: `BatchOperationsPage` 提供批次操作 UI，支援參數設定 (Folder/Label) 與復原 (Undo)。

## 3. 同步架構 (Sync Architecture)

### 3.1 策略：Frontend-Driven ALL MAIL Sync
*   **Client-Side Sync**: 前端 (Flutter) 直接透過 Provider REST API (如 Gmail API) 進行同步。後端 (Cloudflare Workers) 僅負責 AI 輔助與設定同步，不經手郵件內容。
*   **核心**: 放棄傳統 Per-Label 同步，改用 Gmail 推薦的 `ALL MAIL` 同步。
*   **優勢**: 消除重複 (De-duplication)，減少 ~13% API 呼叫，簡化 Token 管理。
*   **Label Optimization**: `GmailRepository.getLabels` 僅從 API 獲取資料夾列表，**計數 (Counts)** 則從本地資料庫聚合，避免對每個 Label 發起額外 API 請求 (N+1 問題)。
*   **流程**: Fetch ALL -> 本地 `_deriveFolderId()` 分類 -> 儲存。
*   **優先級**: Trash > Spam > Draft > Sent > Inbox > Custom > Archive。
*   **Outlook 支援**: `OutlookProvider` 採用 **Microsoft Graph API** (v1.0) 實作。目前使用標準 REST 分頁 (`$top`, `$search`)，**尚未**實作 Delta Query 增量同步。OAuth Token 刷新由 `OAuthTokenRefreshService` 代理至後端執行。

### 3.2 雙重同步模式
1.  **Full Diff Sync (完整差異)**: 用於首次/過期。Fetch IDs -> Record Remote -> Find Missing -> Download Metadata -> Delete Stale.
    *   **抗 429**: 自動縮減 Batch Size (50->30->15) 並暫停 PageToken。
2.  **Reconciliation (對帳模式)**: 抓取**所有** Metadata 更新本地狀態 (Read/Flag)，修正 Drift。

### 3.3 背景與離線機制 (Background & Offline)
*   **Isolates**: 使用 `IsolateManager` 生成 Background Isolate (`background_sync`)，防止同步卡頓 UI。
*   **Task Scheduling**: `BackgroundSyncService` 實作優先級任務佇列 (`_scheduledTasks`)，支援任務依賴 (Dependencies) 與重試機制 (Retry Policy)。
*   **Offline Queue**: `OfflineQueueService` 攔截無網路時的 API 操作 (Read/Delete/Archive)，待網路恢復後自動重放。
*   **Sync Conflicts**: 偵測本地與遠端狀態衝突 (`SyncConflict`)，採用 "Ask User" 策略（預設）。
*   **健康監控**: `Drift` 監控同步落差，閾值 <5% 為健康。
*   **State Management (SSOT)**: `SyncStateManager` 統一管理記憶體、檔案快取與資料庫中的 Sync Cursor (PageToken + HistoryId)。
    *   **Concurrency**: 實作 `Capture Window` (凍結增量更新), `Deletion Phase` (暫停同步), `Repair Mode` (全量修復) 三種鎖定狀態。
    *   **Repair Mode**: `MailboxBloc` 支援 `RepairSync` 機制。觸發時會清除所有 Cursor，捕捉當前 `historyId`，執行全量對帳 (Reconciliation)，最後再執行一次增量同步以確保數據一致性。

### 3.4 快取一致性 (CAS-Lite)
*   **Cache Manager**: `CacheManager` 提供通用的雙層快取 (Memory + Disk)，支援 LRU 淘汰與過期機制。
*   **Email Cache Service**: `EmailCacheService` 專門負責郵件的持久化 (JSON file-based)，支援 Account-level 與 Folder-level 的快取結構，並保存同步游標 (`pageToken`, `historyId`)。
*   **組件**: `EmailCacheCoordinator` 協調 Database 與 CacheService。
*   **機制**: 寫入快取前重新讀取最新 Snapshot 並合併 (Merge)，防止並發寫入覆蓋。
*   **策略**: Stale-while-revalidate (優先回傳過期快取，背景更新)。
*   **搜尋快取**: `EmailSearchService` 實現 Cache-First 策略，緩存搜尋結果與列表過濾 (Starred/Read) 5-10 分鐘。

### 3.5 跨裝置同步 (Cross-Device Sync)
*   **SyncService**: 負責同步設定 (`syncSettings`) 與帳號列表 (`syncAccounts`) 至後端。
*   **Debounce & Timeout**: `startSync` 具有最小 1 分鐘的防抖動機制，以及 10 秒的超時保護，防止頻繁同步或卡頓。
*   **Conflict Resolution**: 偵測設定版本衝突 (`409 Conflict`) 並支援 `resolveConflict` API 進行解決。
*   **Transfer**: 支援透過 QR Code (`generateQRCode`/`consumeQRCode`) 進行加密的帳號轉移。

### 3.6 標準協定實作 (Standard Protocols)
*   **IMAP Implementation**: `IMAPHandler` 提供完整的 IMAP4rev1 實作。
    *   **Features**: SSL/StartTLS 支援, 狀態機管理 (Connecting/Authenticated/Selected), 指令標籤管理, 異步回應解析.
    *   **Commands**: LOGIN, LIST, SELECT, SEARCH, FETCH, STORE, EXPUNGE, MOVE, CAPABILITY.
    *   **Parsing**: `IMAPResponseParser` 負責解析複雜的 IMAP 回應結構 (Folders, Search Results, Fetch Data).
*   **POP3 Implementation**: `POP3Handler` 實作標準 POP3 協定。
    *   **Features**: `USER`/`PASS` 認證, `STLS` 升級, 客戶端分頁 (LIST/RETR), 本地搜尋 (因不支援伺服器端搜尋).
*   **SMTP Implementation**: `SMTPHandler` 實作郵件發送協定。
    *   **Features**: `AUTH LOGIN`, `STARTTLS`, `EHLO`/`HELO` 握手, Multipart/Alternative MIME 建構.
*   **JMAP Implementation**: `JMAPClient` 實作現代化郵件協定。
    *   **Features**: Session Discovery, Batch Calls, EventSource, Blob Management, Push Notifications.
*   **Exchange EWS**: `EWSClient` 實作 SOAP/XML 協定。
    *   **Features**: Item/Folder Operations, Calendar, Contacts, Out-of-Office, Push Subscriptions.
*   **ProtonMail**: 採用多模式架構 (`ProtonMailConnectionMode`)。優先嘗試偵測本地 **ProtonMail Bridge** (IMAP/SMTP)，若失敗則回退至內建 PGP (Stub) 或 Web API 模式。
*   **Notion Integration**: `NotionProvider` 實作了專用的 Database Schema 映射，將 `TodoStatus` (Not started/In progress/Done) 與 `Priority` (Low/Medium/High/Urgent) 轉換為 Notion Select 屬性。

*   **生產力工具整合 (Productivity Integration)**:
    *   **Calendar UI**: `CalendarViewWidget` 支援 Day/Week/Month 三種視圖，並針對不同 Provider (Google/Microsoft/Apple) 進行事件顏色區分。
    *   **Microsoft Integration**:
        *   **Calendar**: `MicrosoftCalendarProvider` 實作了 Calendar 與 Event 的 CRUD 操作，支援 OAuth 認證與 Sync 流程。支援色彩映射與狀態轉換。
    *   **To Do**: `MicrosoftTodoProvider` 實作了 Task List 與 Task 的 CRUD 操作，包含優先級映射 (High/Normal/Low) 與狀態管理 (Completed/NotStarted)。
*   **Automation & Templates**:
    *   **Batch Operations**: `BatchOperationService` 提供批次操作邏輯 (Process, Undo)，並包含 **Smart Suggestions** 功能 (基於寄件者/主旨分組建議)。
    *   **Template Service**: `TemplateService` 實作了變數自動填充 (Auto-fill) 與上下文感知建議 (Suggest based on AI Analysis)。

## 4. AI 架構 (Apple Intelligence)

### 4.1 本地推論架構
*   **Provider**: `FoundationAIProvider` 介接 Apple Foundation Models。
*   **混合策略 (Hybrid AI)**: `HybridAIProvider` 負責執行策略調度。
    *   **Fallback Logic**: 優先嘗試本地模型，若捕獲 `LocalAIUnavailableException`、`UnsupportedError` 或特定 `PlatformException`，則自動回退至遠端 Provider。
*   **併發控制**: `AiSessionSemaphore` 限制同時運行的本地模型實例。
*   **隱私**: 數據不離機（Local 模式）。
*   **Lifecycle**: `FoundationModelsFramework` 透過 `LanguageModelSession` 管理 Native Session 的創建、預熱 (Prewarm)、Prompt Routing 與銷毀。

### 4.2 後端 AI 服務 (Backend AI Service)
*   **Provider Factory**: `AIServiceFactory` 負責根據環境變數與設定創建具體的 AI Provider (OpenAI, Anthropic, OpenRouter)。
*   **Config**: `AISummaryConfig` 統一管理摘要長度 (350字) 與策略 (Ensure vs Regenerate)，確保一致體驗。
*   **Proxy Role**: 後端作為安全代理，隱藏 API Keys，並附加 Caching (KV) 與 Usage Tracking (KV + D1) 功能。
*   **AI Service**: 透過 `AIServiceFactory` 動態載入 Provider (OpenAI/Anthropic/OpenRouter)。
*   **Tracking**: 使用 `trackDetailedAIUsage` 記錄 Token 用量與請求延遲。
*   **Tool Handlers**: 
    *   `SecuritySignalsToolHandler`: 封裝 `SimpleSecurityAnalyzer`，提供標準化 JSON 安全報告。
    *   `QuotaToolHandler`: 提供統一的配額狀態查詢介面。
    *   `UrlReputationToolHandler`: 提供 URL 安全性評估與上下文關聯。
*   **Tool Handlers**: 
    *   `SecuritySignalsToolHandler`: 封裝 `SimpleSecurityAnalyzer`，提供標準化 JSON 安全報告。
    *   `QuotaToolHandler`: 提供統一的配額狀態查詢介面。
    *   `UrlReputationToolHandler`: 提供 URL 安全性評估與上下文關聯。
*   **Security Analysis**: `analyze-security` 端點採用基於規則 (Rule-Based Heuristics) 的實作 (`computeRuleBasedSecurity`)，避免將敏感郵件內容傳送至 LLM 進行風險評估，並優化回應速度。
    *   **Rule-First Strategy**: 前端 `FoundationAIProvider` 實作了 "Rule-First" 策略。若本地規則偵測到 High/Critical 風險，將直接採用規則結果，防止 LLM 產生幻覺或錯誤降級風險等級。僅在低風險時使用 LLM 補充說明。

### 4.3 智慧任務調度 (Intelligent Scheduling)
*   **AiTaskQueueService**: 負責本地啟發式決策與任務排程。
    *   **Newsletter Detection**: 自動偵測電子報關鍵字（如 "unsubscribe"），調整摘要策略。
    *   **HTML Fallback**: 當純文字內容僅包含 "View in browser" 等佔位符時，自動切換至 HTML 內容進行分析。
    *   **優先級**: Urgent (User Action) > High (All High) > Medium (Auto) > Low (Background)。

### 4.4 內容壓縮 (Content Compression)
*   **Fast Path**: <4.8k chars, <1.5s.
*   **Standard Path**: 4.8k-24k chars, <4s.
*   **Complex Path**: >24k chars, <8s (啟用壓縮)。
*   **Token 估算**: 使用 `TokenEstimator` 進行精確的 CJK/混合語言 Token 計算，確保不超出 Context Window (4096 tokens)。
    *   **Ratios**: 基於實測校正：繁體中文 0.8 tokens/char (1.25 chars/token)，英文/其他 0.35 tokens/char (2.86 chars/token)。

### 4.4 內容壓縮 (Content Compression)
*   **算法**: HTML->Markdown (省50%+) + 保留頭尾 (5k/3k chars) + 實體提取 (URL/Date/Money) 補回。
*   **啟發式 (Heuristics)**: 自動偵測 "Click to view" 佔位符，強制改用 HTML 摘要。
*   **遞迴摘要 (Recursive)**: 針對超長內容自動分塊摘要再合併。
*   **電子報優化**: `NewsletterCleaner` 專門處理電子報結構，提取摘要 (`NewsletterDigestPayload`) 與關鍵連結。
*   **Sanitization**: `TextSanitizer` 處理 UTF-16 異常代理對，確保 LLM 輸入與 UI 渲染安全。

### 4.5 任務佇列 (AiTaskQueueService)
*   **持久化**: `ai_task_queue` 表 (Drift/SQLite)。
*   **優先級**: Urgent (User Action) > High (All High) > Medium (Auto) > Low (Background)。
*   **智能策略**: 
    *   **Newsletter Detection**: 檢測 "unsubscribe", "view in browser" 等關鍵字，調整摘要策略。
    *   **HTML Fallback**: 若 Plain Text 僅包含佔位符，自動切換至 HTML 內容進行分析。
*   **機制**: 防重複 (Deduplication)、優先級升級 (Priority Upgrade)、指數退避重試 (Exponential Backoff)。
*   **監控**: 提供 `AiQueueSnapshot` 串流，即時監控 Pending/Running/Failed 狀態。

### 5. 資料庫設計 (Database Schema)

### 5.1 核心表結構 (Drift/SQLite)
*   `emails_table`: 複合索引優化查詢效能 (`idx_emails_account_unread_received`, `idx_emails_account_starred_received`, `idx_emails_account_folder_received`, `idx_emails_has_full_content`)。
*   `sync_metadata`: 儲存 `page_token` (Resumable Sync), `history_id`, `last_sync`。
*   `ai_task_queue`: 持久化 AI 任務佇列，支援優先級排程與重試。
    *   **Schema**: `email_id`, `account_id`, `task_type` (title/summary/security), `priority`, `status` (pending/running/completed/failed), `attempts`, `last_error`, `scheduled_at`.
    *   **Indexes**: `idx_ai_queue_status_priority`, `uniq_ai_pending_running` (Deduplication), `idx_ai_queue_email_type`.
*   `drafts_table`: 草稿，包含 `idx_drafts_account_updated` 與 `idx_drafts_created` 索引。
*   `temp_remote_ids`: 用於同步比對的暫存表。

### 5.2 全文檢索 (FTS5)
*   **Virtual Tables**: `emails_fts` 與 `drafts_fts` 使用 SQLite FTS5 模組。
*   **自動同步 (Triggers)**:
    *   `emails_fts_insert`, `emails_fts_update`, `emails_fts_delete` 觸發器確保主表與 FTS 表數據即時一致。
    *   `drafts_fts_insert`, `drafts_fts_update`, `drafts_fts_delete` 觸發器確保草稿表與 FTS 表數據即時一致。
    *   **UNINDEXED Columns**: `id`, `account_id` 等欄位設為 UNINDEXED 以節省空間並僅用於關聯。
*   **效能**: 搜尋回應 <100ms。

### 5.3 後端資料庫 (Cloudflare D1)
*   `users`, `subscriptions`, `payments`.
*   **AI Usage**: `ai_usage` (每日聚合), `ai_usage_logs` (詳細請求日誌: provider, model, tokens, cache_hit).
*   **Sync**: `account_sync` (加密的帳號 Blob), `user_settings_sync`.

### 5.4 後端任務架構 (Backend Jobs)
*   **Job Manager**: `JobManager` 負責註冊與執行排程任務 (Cron Triggers).
*   **Implemented Jobs**:
    *   `CleanupJob`: 清理過期日誌與暫存數據。
    *   `UsageResetJob`: 重置用戶 AI/API 使用配額。
    *   `HealthCheckJob`: 定期自我檢測系統健康度。

## 6. 安全架構

*   **OAuth Token Vault**: 本地僅存 opaqueId，Refresh Token 存於後端 Vault (Mock階段)，支援撤銷/輪替。
*   **Rate Limiting**: 
    *   **Client**: 實作 Exponential Backoff (500ms/1s/1.5s)。
    *   **Backend**: 全域 Rate Limit 改用 Cloudflare Dashboard 規則。敏感端點 (Auth/OAuth/AI) 採用 `rateLimitMiddleware`，並實作 **In-Memory Cache (10s TTL)** 以大幅減少 KV 讀寫成本 (~90%)。
*   **傳輸**: TLS 1.3。
*   **Account Transfer**: 透過 QR Code 交換加密的 Refresh Token (Ephemeral Key Encrypted) 實現裝置間安全轉移。
*   **Local Security Analyzer**: `SimpleSecurityAnalyzer` 執行本地啟發式檢查 (Sender Mismatch, Link Anomalies, Brand Impersonation)。
*   **PGP**: `PGPService` 介面已定義，目前採用 **Mock (Base64)** 實作，真實加密邏輯待整合 `openpgp_dart`。
*   **Secure Storage**: 使用 `StatePersistenceService` 與 `DeviceIdService` 封裝 `flutter_secure_storage`。
    *   **Encryption Service**: 採用 `compute()` Isolate 卸載繁重的加密運算 (Key Derivation, Encryption)。**注意**: 目前實作僅為 XOR 示範，需升級至 AES-GCM。
    *   **Credential Manager**: `CredentialManager` 提供進階憑證管理，實作 **Master Key Encryption** (雙重加密)，使用隨機生成的 Master Key 加密所有憑證資料，再將 Master Key 存入 Secure Storage。
    *   **Reliability**: `UsageTrackingService` 針對 macOS Keychain `-25299` (Duplicate Item) 錯誤實作了 4 階段刪除重試策略 (Old Options -> No Options -> Mac Options -> All Options)。
*   **Biometrics**: `BiometricService` 整合 `local_auth`。
    *   **強度檢測**: 支援 `getBiometricStrength()` 區分 `strong` (FaceID/Fingerprint) 與 `weak` 生物辨識。
    *   **偏好設定**: 支援使用者開關 (`setBiometricEnabled`) 與類型記憶。
    *   **State Management**: 使用 `SharedPreferences` 持久化使用者偏好 (`biometric_enabled`, `biometric_type`)。

### 7.3 開發與維護腳本
*   **Test Runner**: `scripts/test-runner.sh` 統一執行單元與整合測試，支援 Coverage Threshold (90%) 檢查與 HTML 報告生成。
*   **Desktop Tests**: `scripts/run_desktop_tests.sh` 針對 macOS 桌面環境執行測試。
*   **Deployment**: `deploy_ios.sh`, `deploy_android.sh` 自動化部署流程。
*   **Fixes**: `fix_keychain.sh` 解決常見的 macOS Keychain 簽章問題。
*   **Unified OAuth**: `UnifiedOAuthService` 統一管理 Google/Apple 登入，並透過 `OAuthErrorReporter` 回報錯誤。
*   **Platform OAuth**: 
    *   **Windows**: `WindowsOAuthService` 使用系統瀏覽器與 Custom Scheme (`awesome-mail://`) 進行認證。**注意**: 目前 `PlatformOAuthService` Factory 暫時回傳 Fallback 實作，需啟用後方可使用。
    *   **Web**: `WebOAuthService` 使用 Google Identity Services (GIS) 與 `dart:js_interop` 進行 Web 端認證。**注意**: 目前 `PlatformOAuthService` Factory 暫時回傳 Fallback 實作。

## 7. 測試策略 (Testing Strategy)

*   **單元測試 (Unit)**: 覆蓋邏輯/Model/Utils (70%).
*   **Widget 測試**: UI 渲染/互動 (20%)，包含 Golden Tests (`goldens/`).
*   **整合測試 (Integration)**: 完整流程 (10%) (`integration/`).
*   **效能測試 (Performance)**: 
    *   **閾值**: Scroll (450ms/550ms), Composite (700ms/900ms).
    *   **工具**: `scripts/run_desktop_tests.sh` (序列化執行避免搶佔).