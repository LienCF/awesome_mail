# 🚀 Awesome Mail Flutter - 需求規格 (Requirements)

## 1. 功能需求 (Functional Requirements)

### 1.1 郵件管理 (Core Email)
*   **多帳號**: Gmail (OAuth) **[已實現]**, Outlook/Yahoo (規劃中).
*   **列表體驗**: 
    *   **無限捲動**: DB 分頁 + API 增量載入 **[已實現]**.
    *   **拖放 (Drag & Drop)**: 支援拖曳歸檔/移動 (基礎建設已完成).
    *   **批次操作**: 封存/刪除/標記 **[已實現]**，支援 **Undo History (復原堆疊)** **[基礎建設已完成]**.
    *   **Smart Suggestions**: 根據模式自動建議批次動作 (e.g., "Move newsletters") **[部分實現 (AI Drawer)]**.
*   **閱讀**: HTML/Text 渲染，圖片阻擋 (隱私) **[已實現]**.
*   **撰寫**: Rich Text (Quill)，附件，AI 輔助 **[已實現]**.

### 1.2 搜尋 (Search)
*   **FTS5 全文檢索**: 毫秒級本地搜尋 (Subject, Body, Sender) **[已實現]**.
*   **運算子**: `from:`, `to:`, `is:unread`, `has:attachment`, `older_than:` **[已實現]**.
*   **建議**: 歷史紀錄與聯絡人建議 **[已實現]**.

### 1.3 AI 智慧功能 (Apple Intelligence)
*   **摘要 (Summarize)**: 重點/待辦提取，支援長郵件壓縮 **[已實現 (AI Drawer)]**.
*   **回覆 (Reply)**: 上下文感知建議 **[已實現 (AI Drawer & Composer)]**.
*   **安全分析 (Security)**: 
    *   釣魚/惡意軟體偵測 **[已實現 (MessageBanner)]**.
    *   **Punycode 域名** 識別 **[已實現]**.
    *   **緊急語言 (Urgency)** 詐騙特徵識別 **[已實現]**.
*   **標題生成**: 自動生成簡潔標題 **[已實現]**.

### 1.4 自動化與生產力
*   **規則引擎 (Rule Engine)**:
    *   條件: Regex, 數值比較, 邏輯組合 (AND/OR) **[後端 Schema 支援]**.
    *   動作: Webhook, 本地通知, 自動回覆, 轉寄, 標記.
*   **待辦事項**: 郵件轉任務 (To-Do) **[已實現 (AwesomeTodoList)]**.

### 1.5 設定與商業化
*   **Adaptive UI**: macOS 緊湊風格 vs Mobile 原生風格 **[macOS 風格已實現]**.
*   **IAP**: 訂閱制 (Mock 實作中)，解鎖 AI/無限帳號 **[前端 UI 與後端 API (Mock) 已實現]**.

## 2. 非功能需求 (Non-Functional Requirements)

### 2.1 效能 (Performance)
*   **啟動時間**: < 1.5s.
*   **列表 FPS**: 60fps (虛擬化渲染) **[已優化]**.
*   **同步速度**:
    *   Metadata (200 items): < 5s.
    *   Metadata (4000 items/full): < 30s.
*   **AI 延遲 (p95)**: Fast < 1.5s, Standard < 4s, Complex < 8s.
*   **搜尋**: < 100ms **[FTS5 已達成]**.

### 2.2 安全性 (Security)
*   **Token**: Vault 架構 (Opaque ID)，System Keychain 儲存 **[已實現]**.
*   **API**: TLS 1.3，Rate Limit Backoff.
*   **隱私**: AI 本地推論 (部分)，無數據上雲 (架構支援).

### 2.3 可靠性 (Reliability)
*   **Sync Drift**: < 5% (Healthy).
*   **Crash Rate**: < 0.1%.
*   **Recovery**: 自動修復機制 (Auto-repair) 需在 10 分鐘內解決 Drift **[基礎建設已實現]**.

## 3. 限制條件 (Constraints)
*   **Flutter**: >= 3.35.2
*   **Dart**: >= 3.9.0
*   **AI 需求**: iOS 18.1+, macOS 15.1+ (Foundation Models).
