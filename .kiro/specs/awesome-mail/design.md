# Awesome Mail Flutter - 設計規範 (Design)

## 1. 系統架構與原則

本專案採用 Clean Architecture 與 BLoC 狀態管理模式，並強調「平台適應 (Adaptive)」、「隱私優先 (Privacy-First)」與「高效能 (High Performance)」。

### 1.1 核心設計理念
*   **平台適應 (Adaptive)**:
    *   **桌面端 (macOS)**: Native Look & Feel (Cupertino)，高密度排版，滑鼠/鍵盤優化。
    *   **行動端 (iOS/Android)**: 觸控優先，符合 iOS Human Interface & Material Design 3。
    *   **策略**: **智慧元件層 (Smart Component Layer)** -邏輯共用，視圖分流。
    *   **實作**: `AdaptiveWidgets` 與 `AwesomeOptionPicker` 自動適配 Popup Surface (macOS) 與 Action Sheet (iOS)。
    *   **反饋**: `AdaptiveFeedback` 根據平台選擇 SnackBar (Mobile) 或 CupertinoDialog (Desktop)。
    *   **導航 (Routing)**: `AppRouter` 整合 BLoC 權限控管，並根據平台自動切換首頁 (`MacOSHomePage` vs `HomePage`)。
    *   **原生通道 (Native Channels)**: 使用 `MethodChannel` 整合原生功能 (`awesome_mail/menu`, `awesome_mail/memory`, `awesome_mail/oauth`, `awesome_mail/writing_tools`, `awesome_mail/app_intents`)。
*   **隱私優先**: AI 運算皆在本地 (On-Device) 執行；OAuth Token 採用 Vault 結構儲存。
*   **Database-First**: UI 優先從本地資料庫讀取，背景非同步更新，確保即時響應。
*   **Plugin-First Architecture**: 透過 `PluginRegistry` 與 `PluginInterface` 實現功能模組化 (Email/UI/AI/Automation)，支援動態載入與權限管理。
*   **Environment-Aware**: 透過 `EnvironmentConfig` 與 `AwesomeMailConfig` 支援多環境 (Dev/Staging/Prod) 切換與功能開關 (Feature Flags)。

### 1.2 依賴注入與生命週期 (Dependency Injection)
為確保全域狀態一致性，關鍵 BLoC/Cubit 必須採用單例模式：
*   **@singleton**: `MailboxBloc` (郵箱狀態), `AccountManagementCubit` (帳號選擇), `AppBloc` (App生命週期), `SettingsBloc`, `AuthBloc`, `SyncBloc`, `PluginRegistry`, `RemoteConfigService`, `UpdateService`, `DeviceIdService`, `UsageTrackingService`, `MetricsService`, `BiometricService`, `HttpClient`, `ApiClient`, `UnifiedOAuthService`, `OAuthErrorReporter`, `PaymentService`, `SubscriptionService`.
*   **@injectable (Factory)**: `ComposeBloc` (多視窗撰寫), `AccountSetupBloc` (獨立流程), `DownloadProgressCubit` (下載狀態), `SearchBloc`.
*   **機制**: 使用 `get_it` 與 `injectable` 進行管理，支援環境變數注入 (e.g., `backendBaseUrl`). `CoreModule` 負責註冊 Dio, SecureStorage, PackageInfo 等基礎服務。

## 2. UI 設計系統 (Awesome Design System)

### 2.1 Design Tokens
*   **檔案**: `lib/shared/themes/macos_design_system.dart` (macOS), `awesome_design_system.dart` (Shared).
*   **色彩**: `AwesomeColors`支援動態取色 (Light/Dark).
*   **排版**: `MacOSTypography` (SF Pro 風格)。
*   **動畫**: `AwesomeAnimation` (Fast: 150ms, Normal: 250ms)，`AwesomeTransitionBuilder` 支援頁面轉場。
*   **擴充 (Theme Extension)**: `AwesomeThemeExtension` 提供特定語義顏色 (Sidebar, Chip, Security)，支援 `AwesomeThemeBuilder` 統一建構。
*   **Adaptive Design System**: `AdaptiveDesignSystem` 類別統一管理跨平台的 Colors, Typography, Spacing 與 Dimensions，自動適配 Desktop/Mobile。

### 2.2 關鍵組件
*   **macOS 原生增強**: `MacOSWindow` (交通燈, 標題列), `MacOSSidebar` (收折, 徽章), `MacOSEnhancedToolbar`.
*   **適配層**: `AdaptiveWidgets` 工廠 (自動切換 MacOS/Material 實作).
*   **列表虛擬化**: `EmailListWidget` 支援 >1000 項目高效渲染，整合 `DragDropController`。
    *   **EmailListItem**: 支援滑動操作 (Swipe Actions) 與拖曳 (Drag & Drop)。
*   **AI 面板**: `AwesomeAIDrawer` (右側滑出)，含摘要/回覆建議/對話分頁。`EmailClassificationWidget` 提供視覺化的分類信心與情感指標。
    *   **AI Assistant**: `AIConversation` 提供即時的自然語言郵件助理介面。
*   **鍵盤導航**: `AwesomeKeyboardShortcuts` 支援 Gmail 風格快捷鍵 (j, k, c, e, #, /, etc.) 與批次操作快捷鍵。
*   **Rich Text Editor**: 基於 `flutter_quill` 封裝的 `RichTextEditor`，整合 AI 寫作輔助與附件管理 (Max 25MB)。
    *   **AI Writing Assistant**: `AIWritingAssistant` Dialog 提供風格分析與建議生成。
    *   **Attachment Panel**: `AttachmentPanel` 管理附件列表。
*   **Message Banner**: `MessageBanner` 與 `SecurityMessageBanners` 提供統一的狀態與安全警示 UI。
*   **App Button**: `AppButton` 提供統一的按鈕樣式封裝。
*   **Contacts Integration**: `ComposeBloc` 具備處理收件人 (To/Cc/Bcc) 變更的邏輯，預留了與 `ContactRepository` (未來實作) 整合的介面。
*   **Feature Discovery**: `OAuthFeatureDiscoveryWidget` 提供新功能引導動畫。
*   **Platform Integrations**:
    *   **URL Launcher**: `EmailMinimalWebView` 使用 `url_launcher` 攔截並開啟外部連結。
    *   **File Picker**: `BackupSettingsPage` 使用 `file_picker` 匯入設定檔。
    *   **Share Plus**: `BackupSettingsPage` 與 `QRGeneratorPage` 使用 `share_plus` 分享檔案與連結。
    *   **App Intents**: `AppIntentService` 透過 `awesome_mail/app_intents` 通道支援 `summarizeMail` 與 `explainRisk` 原生捷徑指令。
    *   **Native Menu**: `MenuService` 透過 `awesome_mail/menu` 通道處理 macOS 選單動作 (File, Edit, View, Email, Account, Tools, Help)。
*   **Batch Operations**: `BatchOperationsPage` 提供批次操作 UI，支援參數設定 (Folder/Label) 與復原 (Undo)。

## 3. 同步架構 (Sync Architecture)

### 3.1 策略：Frontend-Driven ALL MAIL Sync
*   **Client-Side Sync**: 前端 (Flutter) 直接透過 Provider REST API (如 Gmail API) 進行同步。後端 (Cloudflare Workers) 僅負責 AI 輔助與設定同步，不經手郵件內容。
*   **核心**: 放棄傳統 Per-Label 同步，改用 Gmail 推薦的 `ALL MAIL` 同步。
*   **優勢**: 消除重複 (De-duplication)，減少 ~13% API 呼叫，簡化 Token 管理。
*   **流程**: Fetch ALL -> 本地 `_deriveFolderId()` 分類 -> 儲存。
*   **優先級**: Trash > Spam > Draft > Sent > Inbox > Custom > Archive。
*   **Outlook 支援**: `OutlookProvider` 實作了基礎的 Microsoft Graph API 整合 (`fetchEmails`, `sendEmail`)，但目前採用標準的 Polling 機制，尚未整合進 Gmail 的 `historyId` 增量架構。

### 3.2 雙重同步模式
1.  **Full Diff Sync (完整差異)**: 用於首次/過期。Fetch IDs -> Record Remote -> Find Missing -> Download Metadata -> Delete Stale.
    *   **抗 429**: 自動縮減 Batch Size (50->30->15) 並暫停 PageToken。
2.  **Reconciliation (對帳模式)**: 抓取**所有** Metadata 更新本地狀態 (Read/Flag)，修正 Drift。

### 3.3 背景與離線機制 (Background & Offline)
*   **Isolates**: 使用 `IsolateManager` 生成 Background Isolate，防止同步卡頓 UI。
*   **Offline Queue**: `OfflineQueueService` 攔截無網路時的 API 操作 (Read/Delete/Archive)，待網路恢復後自動重放。
*   **Sync Conflicts**: 偵測本地與遠端狀態衝突 (`SyncConflict`)，採用 "Ask User" 策略（預設）。
*   **健康監控**: `Drift` 監控同步落差，閾值 <5% 為健康。

### 3.4 快取一致性 (CAS-Lite)
*   **組件**: `EmailCacheCoordinator`.
*   **機制**: 寫入快取前重新讀取最新 Snapshot 並合併 (Merge)，防止並發寫入覆蓋。
*   **策略**: Stale-while-revalidate (優先回傳過期快取，背景更新)。
*   **搜尋快取**: `EmailSearchService` 實現 Cache-First 策略，緩存搜尋結果與列表過濾 (Starred/Read) 5-10 分鐘。

### 3.5 跨裝置同步 (Cross-Device Sync)
*   **SyncService**: 負責同步設定 (`syncSettings`) 與帳號列表 (`syncAccounts`) 至後端。
*   **Debounce**: `startSync` 具有最小 1 分鐘的防抖動機制，避免頻繁同步。
*   **Timeout**: 同步操作具有 10 秒超時保護，防止介面卡頓。
*   **Transfer**: 支援透過 QR Code (`generateQRCode`/`consumeQRCode`) 進行加密的帳號轉移。

### 3.6 標準協定實作 (Standard Protocols)
*   **IMAP Implementation**: `IMAPHandler` 提供完整的 IMAP4rev1 實作。
    *   **Features**: SSL/StartTLS 支援, 狀態機管理 (Connecting/Authenticated/Selected), 指令標籤管理, 異步回應解析.
    *   **Commands**: LOGIN, LIST, SELECT, SEARCH, FETCH, STORE, EXPUNGE, MOVE, CAPABILITY.
    *   **Parsing**: `IMAPResponseParser` 負責解析複雜的 IMAP 回應結構 (Folders, Search Results, Fetch Data).

### 3.7 生產力工具整合 (Productivity Integration)
*   **Microsoft Integration**:
    *   **Calendar**: `MicrosoftCalendarProvider` 實作了 Calendar 與 Event 的 CRUD 操作，支援 OAuth 認證與 Sync 流程。支援色彩映射與狀態轉換。
    *   **To Do**: `MicrosoftTodoProvider` 實作了 Task List 與 Task 的 CRUD 操作，包含優先級映射 (High/Normal/Low) 與狀態管理 (Completed/NotStarted)。
*   **Automation & Templates**:
    *   **Batch Operations**: `BatchOperationService` 提供批次操作邏輯 (Process, Undo)，並包含 **Smart Suggestions** 功能 (基於寄件者/主旨分組建議)。
    *   **Template Service**: `TemplateService` 實作了變數自動填充 (Auto-fill) 與上下文感知建議 (Suggest based on AI Analysis)。

## 4. AI 架構 (Apple Intelligence)

### 4.1 本地推論架構
*   **Provider**: `FoundationAIProvider` 介接 Apple Foundation Models。
*   **混合策略**: `AIChannelPolicy` 根據設定與裝置狀態切換 Local/Remote。
*   **併發控制**: `AiSessionSemaphore` 限制同時運行的本地模型實例。
*   **隱私**: 數據不離機（Local 模式）。
*   **Lifecycle**: `FoundationModelsFramework` 透過 `LanguageModelSession` 管理 Native Session 的創建、預熱 (Prewarm)、Prompt Routing 與銷毀。

### 4.2 後端 AI 服務 (Backend AI Service)
*   **Provider Factory**: `AIServiceFactory` 負責根據環境變數與設定創建具體的 AI Provider (OpenAI, Anthropic, OpenRouter)。
*   **Proxy Role**: 後端作為安全代理，隱藏 API Keys，並附加 Caching (KV) 與 Usage Tracking (D1) 功能。
*   **Security Analysis**: `analyze-security` 端點目前採用基於規則 (Rule-Based Heuristics) 的實作 (`computeRuleBasedSecurity`)。
    *   **檢測邏輯**: 檢查急迫性字詞 (Urgent Patterns)、行銷關鍵字、URL Userinfo (Credential Embedding)、危險附件副檔名、寄件者/連結網域不匹配、短網址服務、不安全 HTTP 連結。
    *   **評分**: 計算 Phishing/Malware/Spam 分數，並輸出 `overallRisk` (High/Medium/Low) 與建議。

### 4.3 動態路由 (Dynamic Routing)
*   **Fast Path**: <4.8k chars, <1.5s.
*   **Standard Path**: 4.8k-24k chars, <4s.
*   **Complex Path**: >24k chars, <8s (啟用壓縮)。
*   **Token 估算**: 使用 `TokenEstimator` 進行精確的 CJK/混合語言 Token 計算，確保不超出 Context Window (4096 tokens)。

### 4.4 內容壓縮 (Content Compression)
*   **算法**: HTML->Markdown (省50%+) + 保留頭尾 (5k/3k chars) + 實體提取 (URL/Date/Money) 補回。
*   **啟發式 (Heuristics)**: 自動偵測 "Click to view" 佔位符，強制改用 HTML 摘要。
*   **遞迴摘要 (Recursive)**: 針對超長內容自動分塊摘要再合併。
*   **電子報優化**: `NewsletterCleaner` 專門處理電子報結構，提取摘要 (`NewsletterDigestPayload`) 與關鍵連結。
*   **Sanitization**: `TextSanitizer` 處理 UTF-16 異常代理對，確保 LLM 輸入與 UI 渲染安全。

### 4.5 任務佇列 (AiTaskQueueService)
*   **持久化**: `ai_task_queue` 表。
*   **優先級**: Urgent (使用者) > High (增量) > Medium > Low (背景)。
*   **機制**: 防重複 (Deduplication)、優先級升級 (Priority Upgrade)、指數退避重試 (Exponential Backoff)。

## 5. 資料庫設計 (Database Schema)

### 5.1 核心表結構 (Drift/SQLite)
*   `emails_table`: 複合索引 (`account_unread_received`, `has_full_content`)，包含 AI 欄位 (`aiTitle`, `aiSummary`, `securityAnalysis`)。
*   `sync_metadata`: 儲存 `page_token`, `history_id`, `last_sync`.
*   `ai_task_queue`: 儲存待處理的 AI 任務 (`status`, `priority`, `scheduled_at`, `attempts`).
*   `drafts_table`: 草稿 (需補索引: `account_updated`).
*   `temp_remote_ids`: 用於同步比對的暫存表.

### 5.2 全文檢索 (FTS5)
*   **表**: `emails_fts`, `drafts_fts`.
*   **同步**: 使用 SQLite Triggers (`AFTER INSERT/UPDATE/DELETE`) 自動維護。
*   **效能**: 搜尋回應 <100ms。

### 5.3 後端資料庫 (Cloudflare D1)
*   `users`, `subscriptions`, `payments`.
*   **AI Usage**: `ai_usage` (每日聚合), `ai_usage_logs` (詳細請求日誌: provider, model, tokens, cache_hit).
*   **Sync**: `account_sync` (加密的帳號 Blob), `user_settings_sync`.

## 6. 安全架構

*   **OAuth Token Vault**: 本地僅存 opaqueId，Refresh Token 存於後端 Vault (Mock階段)，支援撤銷/輪替。
*   **Rate Limiting**: 客戶端實作 Backoff (500ms/1s/1.5s)。
*   **傳輸**: TLS 1.3。
*   **Account Transfer**: 透過 QR Code 交換加密的 Refresh Token (Ephemeral Key Encrypted) 實現裝置間安全轉移。
*   **Local Security Analyzer**: `SimpleSecurityAnalyzer` 執行本地啟發式檢查 (Sender Mismatch, Link Anomalies, Brand Impersonation)。
*   **PGP**: `PGPService` 介面已定義，核心加密邏輯待實作。
*   **Secure Storage**: 使用 `StatePersistenceService` 與 `DeviceIdService` 封裝 `flutter_secure_storage`，並包含 macOS Keychain 錯誤 (-25299) 自動重試邏輯。
*   **Biometrics**: `BiometricService` 整合 `LocalAuthentication`，提供 FaceID/TouchID 支援。
*   **Unified OAuth**: `UnifiedOAuthService` 統一管理 Google/Apple 登入，並透過 `OAuthErrorReporter` 回報錯誤。
*   **Platform OAuth**: 
    *   **Windows**: `WindowsOAuthService` 使用系統瀏覽器與 Custom Scheme (`awesome-mail://`) 進行認證。
    *   **Web**: `WebOAuthService` 使用 Google Identity Services (GIS) 與 `dart:js_interop` 進行 Web 端認證。

## 7. 測試策略 (Testing Strategy)

*   **單元測試 (Unit)**: 覆蓋邏輯/Model/Utils (70%).
*   **Widget 測試**: UI 渲染/互動 (20%)，包含 Golden Tests (`goldens/`).
*   **整合測試 (Integration)**: 完整流程 (10%) (`integration/`).
*   **效能測試 (Performance)**: 
    *   **閾值**: Scroll (450ms/550ms), Composite (700ms/900ms).
    *   **工具**: `scripts/run_desktop_tests.sh` (序列化執行避免搶佔).