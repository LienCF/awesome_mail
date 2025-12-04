# 📋 Awesome Mail Flutter - 任務追蹤 (Tasks)

## 1. 進行中任務 (In Progress)

### 1.1 設定頁面 UI 重構 (Adaptive UI)
*   **目標**: 建立 `Smart Component Layer`。
*   **Action Items**:
    - [ ] 建立 `AwesomeAdaptiveTile` 抽象元件。
    - [ ] 重構 `GeneralSettingsPage` 使用此元件。
    - [ ] 重構 `AccountSettingsPage`。
    - [ ] 重構 `AppearanceSettingsPage`。

### 1.2 同步 UI 整合
*   **目標**: 讓使用者看見同步狀態與健康度。
*   **Action Items**:
    - [ ] 將 `SyncStatusWidget` (已實作) 整合至首頁 Status Bar 或 Drawer。
    - [ ] 實作同步錯誤/Drift 的 Toast 提示。

### 1.3 搜尋頁面優化 (Search Polish)
*   **目標**: 完善搜尋體驗與篩選 UI。
*   **Status**: Core logic & UI implemented (`SearchPage`, `SearchBloc`).
*   **Action Items**:
    - [ ] 驗證 Filter Chips 的交互細節。
    - [ ] 確認搜尋歷史記錄的持久化體驗。

### 1.4 IAP UI 整合
*   **目標**: 顯示訂閱畫面與功能限制。
*   **Status**: 
    - UI Implemented: `SubscriptionPageImpl`, `PlanComparison`.
    - Backend Ready: `subscriptions.ts` (Status, Upgrade, Mock Stripe).
*   **Action Items**:
    - [ ] 確認 `FeatureGate` 與實際業務邏輯的攔截點 (Connect frontend to backend).
    - [ ] 實作 Upgrade Prompt (Feature Gate 攔截)。

## 2. 待辦任務 (Backlog)

### 2.1 核心功能補完
- [x] **拖放整合**: `DragDropController` 已實作，支援拖曳、Undo History 與 Haptic Feedback。
- [ ] **Batch Undo UI**: 顯示 "已刪除/復原" Snackbar (Controller 有 Undo，需確認 UI 連接)。
- [x] **Smart Suggestions UI**: `AIDrawer` 與 `AIReplySuggestionsWidget` 已整合。
- [x] **Batch Toolbar**: `HomeToolbar` 已整合批次操作 (Select All, Archive, Delete, etc.)。

### 2.2 進階工具
- [x] **Command Palette**: Cmd+K 介面已實作 (`AwesomeCommandPalette`)，支援搜尋與鍵盤導航。
- [x] **Attachment Viewer**: `AttachmentPreview` 已實作，支援圖片與文字預覽。
- [x] **Rule Editor**: 自動化規則編輯 UI (UI & Logic Implemented)。
- [x] **Template Manager**: 郵件範本管理與變數自動填充 (`TemplateService`)。

### 2.3 技術債與優化
- [ ] **Drafts Table Indexing**: 添加 `account_updated` 索引 (參見設計文件)。
- [ ] **Singleton Fixes**: 確認所有全域 Bloc (`MailboxBloc` 等) 註冊為 `@singleton`。

## 3. 測試任務
- [ ] **E2E**: 撰寫 Login -> Sync -> AI Summary 完整流程測試。
- [ ] **Perf**: 執行 `scripts/run_desktop_tests.sh` 並建立基準線。
- [ ] **A11y**: 驗證 VoiceOver 導航順序。

## 4. 已完成里程碑 (Completed)
- [x] **核心架構**: Clean Arch, BLoC, DI (Injectable).
- [x] **資料庫**: Drift, FTS5, Indexes.
- [x] **同步核心**: ALL MAIL Strategy, Incremental Sync, Reconciliation, Auto-repair.
- [x] **AI 核心**: FoundationAIProvider, Dynamic Routing, Task Queue (Priority/Retry).
- [x] **UI 基礎**: Awesome Design System (macOS), 3-pane Layout.
- [x] **UI 進階**: AI Drawer, Message Banner (Security), Composer (Rich Text), To-Do List.
- [x] **JMAP**: Handler & Client 實作.
- [x] **Settings (macOS)**: `MacOSSettingsWidgets` 實作.
- [x] **Backend Subscription**: Subscriptions API, Plans, Mock Stripe Integration.
- [x] **Backend AI**: Endpoints for Classify, Summarize, Reply, Entity, Security.
- [x] **Backend Auth**: OAuth Link/Unlink, Refresh Tokens, User Devices.
- [x] **Security**: `SecurityService` (Anti-phishing, Link Scanning, Privacy Protection).
- [x] **Help System**: `AwesomeHelpSystem` (Getting Started, Shortcuts, FAQ).
- [x] **Automation**: Rule Engine, Visual Rule Builder, Templates.
- [x] **Settings Backup**: Export/Import JSON, Versioning.
- [x] **Metrics**: Frontend Service & Backend Durable Object Proxy.
- [x] **Productivity Tools**: Command Palette, Attachment Viewer, Drag & Drop Controller.
- [x] **Infrastructure**: Biometric Auth, Network Info, Theme Manager, Email Cache, Splash Screen.
- [x] **Enterprise**: Productivity Service (Calendar/Tasks), Remote Config, App Update Service, Backend Logging.
- [x] **Diagnostics**: AI Diagnostics Page (Plugin/Client lifecycle events).
- [x] **Accessibility**: `AccessibilityService` (Semantic announcements, screen reader integration).
- [x] **Diagnostics**: AI Diagnostics Page (Plugin/Client lifecycle events).
- [x] **Accessibility**: `AccessibilityService` (Semantic announcements, screen reader integration).
