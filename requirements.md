# 🚀 Awesome Mail Flutter - 需求規格 (Requirements)

## 1. 功能需求 (Functional Requirements)

### 1.1 郵件管理 (Core Email)
*   **多帳號**: 
    *   **Gmail**: OAuth 登入與 REST API 同步 **[已實現]**.
    *   **Outlook**: OAuth 登入流程 **[已實現]**，基本郵件同步 (REST API) **[已實現]**，進階增量同步 **[待實作 (目前為 Basic Polling)]**.
    *   **Standard IMAP**: 完整支援 SSL/StartTLS, LOGIN, LIST, SELECT, SEARCH, FETCH, STORE, EXPUNGE, MOVE 指令 **[已實現 (IMAPHandler)]**.
    *   **Standard POP3**: 支援 USER/PASS, LIST, RETR, DELE, TOP 指令，客戶端分頁與本地搜尋 **[已實現 (POP3Handler)]**.
    *   **Standard SMTP**: 支援 AUTH LOGIN, STARTTLS, Multipart/Alternative MIME 建構 **[已實現 (SMTPHandler)]**.
    *   **Exchange EWS**: 支援 Exchange 2016+ SOAP 協定，包含 Folder/Item CRUD, Calendar, Contacts, Out-of-Office, Push Notification **[已實現 (EWSClient)]**.
    *   **Yahoo**: 基於 OAuth 與 IMAP/SMTP 協定實作 **[已實現 (YahooProvider)]**.
    *   **iCloud**: 基於 App-Specific Password 與 IMAP/SMTP 協定實作 **[已實現 (ICloudProvider)]**.
    *   **ProtonMail**: 支援 Bridge (IMAP/SMTP), 內建 PGP (Stub), Web API (Stub) 三種模式，具備 Bridge 自動偵測功能 **[已實現 (ProtonMailProvider)]**.
    *   **Enterprise Auto-Config**: 自動偵測企業網域 (Zoho, Fastmail) 並套用預設 IMAP/JMAP 設定 **[已實現 (ProtonMailProvider/AccountConfigService)]**.
    *   **Apple Sign-In**: 支援 Apple ID 登入 (Email/Name scopes) **[已實現]**.
    *   **Unified OAuth**: 統一的 OAuth 服務介面，支援跨平台切換 (`UnifiedOAuthService`) **[已實現]**.
    *   **Platform OAuth**: 
        *   **Windows**: 支援 System Browser 與 Protocol Handler (`WindowsOAuthService`) **[程式碼已實作，目前使用 Fallback Stub]**.
        *   **Web**: 支援 Google Identity Services (GIS) 與 `dart:js_interop` (`WebOAuthService`) **[程式碼已實作，目前使用 Fallback Stub]**.
    *   **OAuth Error Reporting**: 專門的錯誤回報機制 (`OAuthErrorReporter`)，將認證失敗傳送至後端 `/api/v1/logs/oauth-error` **[已實現]**.
    *   **帳號連結 (Link/Unlink Providers)**: 後端 API 已支援，前端 UI 整合中 **[部分實現]**.
    *   **OAuth Onboarding**: 安全登入引導流程 (Feature Discovery UI) **[已實現 (OAuthOnboardingWidget)]**.
    *   **帳號新增流程 (Account Setup)**: 完整的多步驟精靈 (AccountSetupPage) **[已實現]**.
    *   **安全帳號轉移 (Secure Transfer)**: 透過 QR Code 將已登入帳號安全轉移至新裝置 **[已實現 (QR Code)]**.
    *   **Auto-Config**: 支援透過 XML Autoconfig 協定自動探索郵件伺服器設定 **[已實現 (AccountConfigService)]**.
*   **列表體驗**: 
    *   **無限捲動**: DB 分頁 (Default 50 items/page) + API 增量載入 **[已實現]**.
    *   **拖放 (Drag & Drop)**: 支援拖曳歸檔/移動 **[已實現 (DragDropController)]**.
    *   **批次操作**: 
        *   封存/刪除/標記 (Read/Star/Important) **[已實現]**.
        *   移動/複製到資料夾 **[已實現]**.
        *   套用/移除標籤 **[已實現]**.
        *   自動回覆與轉寄設定 (Batch Parameters) **[已實現 (BatchOperationsPage)]**.
        *   復原堆疊 (Undo History): 支援復原操作 (`BatchOperationService`) **[已實現]**.
    *   **Smart Suggestions**: 根據寄件者/主旨模式自動建議批次動作 (e.g., "Move newsletters") **[已實現 (BatchOperationService)]**.
    *   **Badge Counts**: 即時未讀數更新與 Stream 通知 **[已實現 (BadgeNotifier)]**.
*   **閱讀**: HTML/Text 渲染，圖片阻擋 (隱私) **[已實現]**.
    *   **Conversation View**: 支援郵件對話串檢視 (`ConversationView`)，具備展開/摺疊、鍵盤導航 (↑↓, Space) 與快速跳轉功能 **[已實現]**.
    *   **Minimal WebView**: `EmailMinimalWebView` 採用 `flutter_inappwebview` 與自定義 HTML 模板。
    *   **JS Bridge**: 實作 `webviewClick` 與 `openLink` JS Handler，由 Flutter 層統一接管互動與外部連結開啟，提供原生級體驗 **[已實現]**.
    *   **macOS Scrolling**: 注入 JS 實現平滑滾動 **[已實現]**.
*   **撰寫**:
    *   Rich Text Editor (Quill): 支援富文本編輯 **[已實現 (RichTextEditor)]**.
    *   附件處理: 支援圖片 (jpg, png, gif, webp) 與文件 (pdf, doc, docx, txt)，上限 **25MB** **[已實現 (AttachmentPanel)]**.
    *   **Attachment Preview**: 支援圖片 (Image.memory) 與純文字 (UTF-8 decode) 的即時預覽，不支援格式提供 Fallback UI **[已實現 (AttachmentPreview)]**.
    *   **AI 寫作輔助**: 語氣調整、風格分析、智慧建議 **[已實現 (AIWritingAssistant)]**.
    *   **語音輸入 (Voice-to-Text)**: 支援語音轉文字輸入 (需 Microphone 權限) **[已實現]**.
*   **同步核心**:
    *   **Frontend-Driven**: 前端直接對接 Email Provider (Gmail/Outlook) 進行郵件同步，後端僅負責設定與加密帳號列表的同步 **[已確認]**.
    *   **Backend Sync**: `sync.ts` 實作了 `user_settings_sync` (SQLite) 與帳號列表同步 (KV Encrypted Blob)，以及 QR Code 轉移機制 **[已實現]**.
    *   **信件快取 (Cache)**: 
        *   **雙層快取 (Multi-layer)**: 記憶體 (LRU, 1000 items) + 磁碟 (JSON file-based, 10000 items) **[已實現 (CacheManager)]**.
        *   **策略 (Strategy)**: 支援過期時間 (Expiration)、過期標記 (Stale-while-revalidate) 與快取統計 (Hit/Miss rate) **[已實現]**.
        *   **磁碟持久化快取 (Disk Persistence)** **[已實現 (EmailCacheService)]**.
    *   離線操作隊列 (Offline Queue): 支援無網路操作 (Read/Archive/Delete)，連線後自動重試 **[已實現 (OfflineQueueService)]**.
    *   Folder-level Caching **[已實現]**.
    *   **Sync State Manager**: 統一的同步狀態與併發控制 (SSOT) **[已實現 (SyncStateManager)]**.
    *   **Batch Optimization**: `EmailRepositoryImpl.saveEmails` 實作了批次寫入與優化的快取失效機制 (Batch Invalidation)，減少 UI 重繪次數 **[已實現]**.
    *   **Background Sync Service**: 基於 Isolate 的背景同步排程 (Interval: 15-30 mins)，支援衝突檢測與重試 **[已實現 (BackgroundSyncService)]**.
    *   **Smart Prefetch**: 利用 `idx_emails_has_full_content` 索引高效查詢需補全的郵件，優先下載內容 **[已實現 (FullContentDownloadService)]**.
    *   **Cache-First Strategy**: `EmailRepositoryImpl` 針對首頁載入 (Unread/Starred) 實作了快取優先策略，加速冷啟動體驗 **[已實現]**.
    *   **Quota Tool**: `QuotaTool` 提供即時配額查詢 (Usage, Limit, Remaining)，支援多維度 (AI, Storage) 檢查 **[已實現]**.
    *   **Health Auto-Repair**: `SyncHealthChecker` 支援自動修復機制，當偵測到嚴重偏差 (>10%) 時觸發增量同步 **[已實現]**.
    *   **Telemetry**: `SyncMetricsCollector` 收集詳細同步指標 (Success Rate, Latency, API Count)，支援即時監控與 Quota Throttling **[已實現]**.
    *   **Contacts**: (Auto-complete) 雖然未發現獨立的 ContactRepository，但 `ComposeBloc` 的設計暗示未來會透過 `EmailService` 或原生插件整合。
*   **草稿管理 (Drafts)**:
    *   自動儲存 (Auto-save): 背景定時 (30s) 儲存至快取與資料庫 **[已實現 (DraftService)]**.
    *   格式轉換: 支援 Reply/ReplyAll/Forward 格式轉換，自動引用原文與處理 HTML/Text 內容 **[已實現]**.
    *   附件保留: 轉寄時保留原附件 **[已實現]**.

### 1.2 搜尋 (Search)
*   **FTS5 全文檢索**: 針對 SQLite FTS5 優化的全文檢索，涵蓋郵件 (Subject, Body, Sender) 與草稿。
    *   **Triggers**: 實作了 `INSERT`, `UPDATE`, `DELETE` 觸發器，確保 FTS 表與主表數據即時同步 **[已實現 (AppDatabase)]**.
    *   **Drafts FTS**: 草稿同樣支援 FTS5 全文檢索，並具備完整的 Trigger 同步機制 **[已實現 (AppDatabase)]**.
*   **運算子**: `from:`, `to:`, `is:unread`, `has:attachment`, `older_than:` **[已實現]**.
*   **搜尋快取 (Search Cache)**: 查詢結果快取 (5分鐘)，列表結果快取 (10分鐘) **[已實現 (EmailSearchService)]**.
*   **進階篩選 (Flags)**: 支援 `isRead`, `isStarred` 等狀態過濾 **[已實現]**.
*   **建議**: 歷史紀錄與聯絡人建議，支援最近搜尋清除 **[已實現 (SearchPage)]**.

### 1.3 AI 智慧功能 (Apple Intelligence)
*   **後端 API (Hono)**: `/classify`, `/summarize`, `/generate-reply`, `/extract-entities`, `/analyze-security` **[已實現]**.
    *   **Provider Factory**: 後端支援動態切換 OpenAI, Anthropic, OpenRouter **[已實現]**.
*   **混合執行策略 (Hybrid AI)**: `AIChannelPolicy` 自動決策使用本地 Apple Intelligence 或雲端 Cloudflare Workers AI **[已實現]**.
*   **併發控制 (Concurrency)**: `AiSessionSemaphore` 管理本地模型資源，防止過載 **[已實現]**.
*   **限制控制**: 本地端實作 AI 請求速率限制 (100 requests/hour) **[已實現]**.
*   **摘要 (Summarize)**:
    *   **遞迴摘要 (Recursive Summarization)**: 針對長郵件自動分段摘要後合併，支援 Token 預算控制 **[已實現]**.
    *   **Engine Logic**: `SummaryEngine` 實作了串流聚合 (Streaming Aggregation) 與鎖定機制 (Locking) 防止競態條件 **[已實現]**.
    *   **Guided Session**: 所有 AI 引擎皆基於 `GuidedSession` 執行，支援結構化 JSON 輸出與錯誤重試 **[已實現]**.
    *   **Reply Engine**: `ReplyEngine` 支援產生建議列表並轉換為領域模型，具備自動冷卻 (Cooldown) 機制 **[已實現]**.
*   **回覆 (Reply)**: 上下文感知建議，支援不同語氣 (Tone) 與引導式生成 (Guided Session) **[已實現 (AIReplySuggestionsPage)]**.
*   **網路層 (Network Layer)**:
    *   **HTTP Client**: 封裝 Dio，實作統一的 Interceptor (Default Headers, Error Handling) 與 Exponential Backoff Retry (3次重試) **[已實現 (HttpClient)]**.
    *   **API Client**: 高階 API 封裝，支援 `x-refresh-retry` 自動重試與 Rate Limit 處理 **[已實現 (ApiClient)]**.
*   **安全分析 (Security)**: 
    *   **本地啟發式引擎 (Local Heuristics)**: `SimpleSecurityAnalyzer` 檢測寄件者欺騙、連結異常 (Punycode, IP, Credential-in-URL)、品牌偽冒、急迫性字詞 **[已實現]**.
    *   **URL 信譽檢測 (Reputation)**: `UrlReputationTool` 整合 Foundation Models Framework，提供 URL 安全性評分與證據 **[已實現]**.
    *   **後端啟發式分析 (Backend Heuristics)**: 後端 `/analyze-security` 採用規則基礎 (Rule-based) 邏輯以優化成本與速度 **[已實現]**.
    *   **釣魚/惡意軟體偵測**: 整合 `MessageBanner` 顯示釣魚警告、DMARC/SPF 失敗、追蹤像素封鎖等警示 **[已實現]**.
    *   **HTML 淨化 & 追蹤像素阻擋** **[已實現 (PrivacyProtector)]**.
    *   **文字淨化 (Text Sanitizer)**: 處理 UTF-16 異常代理對 (Surrogate Pairs)，防止 LLM 輸入或 UI 渲染崩潰 **[已實現 (TextSanitizer)]**.
*   **標題生成**: 自動生成簡潔標題，支援 Head/Tail 取樣壓縮以適應 Context Window **[已實現]**.
*   **AI 診斷 (Diagnostics)**: 視覺化 AI 事件流與生命週期監控，包含 `AIModelStatusChip` 顯示模型狀態 (Prewarming/Streaming) **[已實現]**.
*   **效能監控 (Performance Monitor)**: `PerformanceMonitor` 追蹤啟動時間、畫面切換、API 回應時間，提供 0-100 效能評分與優化建議 **[已實現]**.
*   **記憶體監控 (Memory Monitor)**: `MemoryMonitor` 追蹤記憶體使用量，偵測洩漏 (Leaks)、尖峰 (Spikes) 與高頻分配物件，支援 GC 建議 **[已實現]**.
*   **AI 分類儀表板 (Dashboard)**: `EmailClassificationWidget` 顯示信心值 (Confidence)、情感 (Sentiment) 與優先級 (Priority) **[已實現]**.
*   **AI 對話助理 (Assistant)**: `AwesomeAIDrawer` 整合 `AIConversation`，提供自然語言查詢 (e.g. "Summarize this", "Create todo") **[已實現]**.
*   **寫作工具 (Writing Tools)**: Apple Intelligence 系統級整合 (`MethodChannel: awesome_mail/writing_tools`) **[已實現]**.
*   **Foundation Models Framework**: 模組化本地模型整合架構，支援 Tool Invocation 與 Stream 響應 **[已實現 (foundation_models_framework package)]**.
*   **AI Init Coordinator**: 模型預熱與就緒狀態協調 **[已實現 (AIInitCoordinator)]**.
*   **Token 估算 (Token Estimator)**: 針對 Apple Intelligence 優化的 CJK/Non-CJK 混合 Token 計算演算法 (CJK: 0.8, Non-CJK: 0.35) **[已實現 (TokenEstimator)]**.
    *   **算法**: 分離計算 CJK/Non-CJK 字元，並針對 JSON 結構符號與換行符號進行加權，預留 20% 安全邊界 **[已實現]**.
*   **持久化任務佇列 (AI Task Queue)**: 資料庫驅動的 AI 任務排程，支援優先級 (Priority)、重試 (Exponential Backoff) 與狀態追蹤。
    *   **Schema**: 包含 `ai_task_queue` 表與 `idx_ai_queue_status_priority` 等索引，確保高效調度 **[已實現 (AppDatabase)]**.
    *   **Retry Logic**: 指數退避策略 (2^n seconds)，上限 5 分鐘 **[已實現]**.
    *   **Missing Fields Query**: 支援快速查詢最近缺少 AI 欄位的郵件，用於背景補全 **[已實現]**.
    *   **Newsletter Detection** (關鍵字偵測) 與 **HTML Fallback** (佔位符偵測) 啟發式策略以優化摘要品質 **[已實現 (AiTaskQueueService)]**.

### 1.4 自動化與生產力
*   **規則引擎 (Rule Engine)**:
    *   條件: Regex, 數值比較, 邏輯組合 (AND/OR), Subject/Sender/Body/Date/Size/Folder matching **[已實現 (EmailRuleEngine)]**.
    *   動作: Webhook, 本地通知 (Notification/Sound), 自動回覆, 轉寄, 標記 (Read/Star/Label/Important/Spam), 移動/複製/刪除 **[已實現]**.
    *   UI: 視覺化編輯器, 範本匯入 **[已實現 (AutomationPage)]**.
*   **待辦事項**: 郵件轉任務 (To-Do) **[已實現 (AwesomeTodoList)]**.
*   **指令面板 (Command Palette)**: 
    *   Cmd+K 介面，支援導航與操作 **[已實現 (AwesomeCommandPalette)]**.
    *   支援模糊搜尋 (Fuzzy Search) 與分類 (Email, Navigation, Application) **[已實現]**.
    *   **快捷鍵整合**: 自動顯示關聯的鍵盤快捷鍵提示 **[已實現]**.
*   **郵件範本 (Templates)**:
    *   CRUD 管理與分類 **[已實現 (TemplateService, TemplatesPage)]**.
    *   **變數自動填充 (Auto-fill)**: 支援 `{{variable}}` 替換與 AI 內容提取 (Sender Name, Date, Context)。內建 AI 提取器 (`extractTemplateVariables`) 與常見變數 (sender_name, date) **[已實現 (TemplateService)]**.
    *   **AI 範本建議 (Context-aware)**: 基於郵件內容標籤與分類自動推薦相關範本，具備相關性評分演算法 **[已實現 (TemplateService)]**.
    *   使用統計 (Usage Stats): 追蹤範本使用頻率與歷史 **[已實現]**.
*   **生產力整合 (Productivity)**:
    *   **多來源行事曆 (Calendar Aggregation)**: 
            *   **Google Calendar**: 
                *   支援讀取/建立事件 **[已實現]**.
                *   **Recurring Events**: 支援重複事件實例展開 (`getRecurringInstances`) **[已實現 (GoogleCalendarProvider)]**.
                *   **Reminders**: 支援 Email, SMS, Popup 提醒設定 **[已實現]**.
            *   **Microsoft Calendar**: 支援 OAuth 認證, CRUD (Create, Read, Update, Delete) 事件, 同步 **[已實現 (MicrosoftCalendarProvider)]**.        *   **CalDAV**: 支援標準 CalDAV 協定同步行事曆 (Protocol Client Implemented) **[已實現 (CalDavClient)]**.
    *   **跨平台待辦 (Task Aggregation)**: 
        *   **Google Tasks**: 支援列表與任務管理 **[已實現]**.
        *   **Microsoft To Do**: 支援 OAuth 認證, 列表管理, 任務 CRUD, 優先級與狀態映射 **[已實現 (MicrosoftTodoProvider)]**.
    *   **聯絡人同步 (CardDAV)**: 支援標準 CardDAV 協定同步通訊錄 (Protocol Client Implemented) **[已實現 (CardDavClient)]**.
    *   **行程衝突偵測**: 自動識別時間重疊並標示嚴重程度 **[已實現]**.
    *   **Backend Integrations**: 
        *   **Notion**: 支援 Database/Page CRUD, Status/Priority Mapping, Rich Text Block 生成 **[已實現 (NotionProvider)]**.
        *   **Todoist**: 支援 Project/Task CRUD, Priority/Label Mapping, Due Date 處理 **[已實現 (TodoistProvider)]**.
    *   **Scheduled Jobs**: 後端排程任務系統 (`JobManager`)，包含 `CleanupJob` (清理), `UsageResetJob` (配額重置), `HealthCheckJob` **[已實現]**.
*   **App Intents**: iOS/macOS 捷徑整合 (Summarize, Risk Report) **[已實現 (AppIntentService)]**.
*   **快捷操作 (Shortcut Actions)**: 鍵盤與手勢指令處理 **[已實現 (ShortcutActionHandler)]**.
*   **鍵盤快捷鍵 (Keyboard Shortcuts)**: Gmail 風格快捷鍵 (j/k 導航, c 撰寫, e 封存, # 刪除) 與批次操作 **[已實現 (AwesomeKeyboardShortcuts)]**.

### 1.5 設定與商業化
*   **Adaptive UI**: macOS 緊湊風格 vs Mobile 原生風格 (Theme/Density/Layout) **[已實現 (AppearanceSettingsPage)]**.
    *   **Resizable Layout**: 支援拖曳調整欄位寬度的雙欄 (`ResizableTwoColumnLayout`) 與三欄佈局，並自動持久化寬度設定 **[已實現]**.
    *   **Awesome Option Picker**: 平台適應性選單 (macOS Popup Surface vs iOS Action Sheet) **[已實現]**.
    *   **Accessibility**: `SemanticAnnouncer` 封裝 `SemanticsService`，支援優先級 (Polite/Assertive) 語音播報 **[已實現]**.
    *   **Theme System**: 完整的主題擴充機制，支援自定義顏色與響應式佈局 (2/3欄) **[已實現 (AwesomeTheme)]**.
    *   **AppButton**: 統一且可客製化的按鈕元件 (Primary/Secondary/Text/Icon) **[已實現]**.
    *   **Email List Item**: 支援滑動手勢 (Swipe Actions) 與拖曳 (Drag & Drop) **[已實現 (EmailListItem)]**.
*   **IAP**: 訂閱制 (UI Implemented, Backend Mocked)，解鎖 AI/無限帳號 **[已實現]**.
    *   **Subscription Service**: 管理訂閱狀態、計劃限制與升級/取消邏輯 **[已實現 (SubscriptionService)]**.
    *   **Usage Tracking**: 追蹤功能使用量 (AI requests, storage) 並執行 Plan Limits **[已實現 (UsageTrackingService)]**.
        *   **Reliability**: 針對 macOS Keychain `-25299` 錯誤實作 4 階段重試與刪除策略 **[已實現]**.
        *   **Features**: 支援 AI Requests, Accounts, Storage, Team Features 等多維度配額檢查 **[已實現]**.
*   **Payments**:
    *   **Payment Service**: 統一支付介面，支援多種 Provider **[已實現 (PaymentService)]**.
    *   **Stripe**: 整合 `flutter_stripe` 處理信用卡支付。後端 `subscription-service.ts` 目前提供 **Mock Service**，包含訂閱建立、取消與 Webhook 處理的模擬邏輯，尚未對接真實 Stripe API **[已實現]**.
    *   **Platform Pay**: 支援 Apple Pay / Google Pay (Mock/Simulated for now) **[已實現 (ApplePayProvider, GooglePayProvider)]**.
*   **設定備份 (Backup)**: 
    *   JSON 匯出/匯入, 版本控制 **[已實現 (SettingsBackupService)]**.
    *   **檔案選擇**: 支援 `file_picker` 匯入備份檔 **[已實現]**.
    *   **分享匯出**: 支援 `share_plus` 分享匯出的備份檔 **[已實現]**.
*   **幫助中心 (Help System)**: 包含 Getting Started, Features, Shortcuts, FAQ **[已實現 (AwesomeHelpSystem)]**.
*   **主題管理 (Theme)**: Light/Dark 模式切換 **[已實現 (ThemeManager)]**.
*   **啟動畫面 (Splash)**: 動畫與狀態檢查 **[已實現 (SplashPage)]**.
*   **遠端配置 (Remote Config)**: 
    *   **Feature Flags**: 控制功能開關 (Toggle) `enableAIFeatures`, `enableOfflineMode` **[已實現 (RemoteConfigService)]**.
    *   **API Endpoints**: 動態配置 API 網址 (`https://api.awesomemail.com/v1/config`)，支援 ETag 快取 (1小時) 與 `304 Not Modified` **[已實現 (RemoteConfigService)]**.
    *   **AI Config**: 集中管理摘要長度 (350字)、標題長度 (100字) 與操作策略 (Ensure vs Regenerate) **[已實現 (AISummaryConfig)]**.
    *   **Experiments**: 支援 A/B Testing (Hash-based assignment) **[已實現]**.
    *   **Maintenance Mode**: 支援遠端維護模式 **[已實現]**.
    *   **Environment Config**: 支援 Dev/Staging/Prod 環境切換 **[已實現 (EnvironmentConfig)]**.
*   **應用更新 (Update)**:
    *   **Update Service**: 跨平台更新檢查 (Sparkle/Store) 與強制更新邏輯 **[已實現 (UpdateService)]**.
*   **本地化 (Localization)**: 多語言支援 (`en`, `zh`, `zh_TW`, `ja`, `ko`, `es`, `fr`, `de`) **[已實現 (AppLocalizations)]**.
*   **原生選單 (Menu Service)**: macOS 系統選單整合 (`MethodChannel: awesome_mail/menu`) **[已實現 (MenuService)]**.
*   **外掛系統 (Plugin Architecture)**: 
    *   **Plugin Registry**: 支援外掛註冊、啟用、禁用與權限驗證 **[已實現 (PluginRegistry)]**.
    *   **Plugin Interface**: 定義了 Email, UI, AI, Automation 等多種外掛類型介面 **[已實現 (PluginInterface)]**.
*   **開發者工具 (Developer Tools)**: 
    *   **複雜郵件渲染測試 (Complex Email Test)** **[已實現]**.
    *   **WebView 測試 (Webview Test)** **[已實現]**.
    *   **佈局溢出偵測 (Resizable Layout Test)** **[已實現]**.
    *   **全域溢出偵錯 (Overflow Debugger)**: 攔截 Flutter 錯誤，分析 `RenderFlex overflowed` 異常，提供 UI 樹上下文與修復建議 **[已實現 (OverflowDebugger)]**.
*   **測試策略 (Testing)**:
    *   **Unit Tests**: 核心邏輯覆蓋 (`test/unit/`) **[已實現]**.
    *   **Widget Tests**: UI 元件互動測試 (`test/widget/`) **[已實現]**.
    *   **Golden Tests**: 視覺回歸測試 (`test/goldens/`)，確保 UI 渲染一致性 **[已實現]**.
    *   **Integration Tests**: 完整流程測試 (`test/integration/`) **[已實現]**.
    *   **Manual Tests**: 手動測試腳本 (`test/manual/`) **[已實現]**.