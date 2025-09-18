# Awesome 風格 UI/UX 重構需求文件

## 簡介

本文件定義了 Awesome Mail Flutter 應用程式的 Awesome 風格 UI/UX 重構需求。此重構旨在模仿 Awesome Mail for Mac 的設計哲學，整合現有的 `.kiro/specs` 規格與既有 Flutter 元件，建立一個現代化、無障礙且高效能的郵件客戶端介面。

Awesome Mail 以其簡潔、優雅的設計和卓越的 macOS 原生體驗而聞名，特色包括：
- 清晰的視覺層次和充足的留白空間
- 精緻的動畫和過渡效果
- 直觀的三欄式佈局
- 優秀的鍵盤快捷鍵支援
- 現代化的 macOS 設計語言

重構將採用 TDD 與小步前進原則，**優先更新和擴展現有的 Flutter 組件**，而非創建全新的實現。重構策略包括：

**核心原則：**
- **更新優於新建**：優先修改現有組件以符合 Awesome 風格，避免創建重複功能的新文件
- **擴展現有系統**：基於現有的 MacOSDesignSystem 與 EnhancedThemeManager 進行擴展
- **保持向後相容**：確保現有功能在更新過程中不會中斷
- **漸進式改進**：採用小步驟更新，每次專注於特定組件的改進

**現有頁面結構（將被更新）：**
- 主頁面：`enhanced_macos_home_page.dart`、`home_page.dart`
- 設定頁面：`enhanced_settings_page.dart` 及各子設定頁面
- 撰寫頁面：`compose_page.dart`
- 搜尋頁面：`search_page.dart`
- 郵件清單：`email_list_widget.dart`、`email_list_item.dart`
- 共用組件：`app_button.dart`、`app_card.dart`、`app_text_field.dart`
- AI 頁面：`ai_classification_page.dart`
- 生產力頁面：`productivity_page.dart`
- 自動化頁面：`automation_page.dart`、`enhanced_automation_page.dart`
- 模板頁面：`templates_page.dart`、`enhanced_templates_page.dart`
- 訂閱頁面：`subscription_page.dart`、`enhanced_subscription_page.dart`
- 認證頁面：`login_page.dart`、`signup_page.dart`、`oauth_login_page.dart`

**現有 UI 元件：**
- macOS 元件：`macos_enhanced_components.dart`、`macos_settings_widgets.dart`
- 郵件元件：`email_list_widget.dart`、`email_list_item.dart`、`attachment_widget.dart`
- AI 元件：`email_summary_widget.dart`、`email_classification_widget.dart`
- 通用元件：`app_button.dart`、`app_card.dart`、`app_dialog.dart`、`app_text_field.dart`
- 適應性元件：`adaptive_design_system.dart`、`adaptive_widgets.dart`

## 需求

### 需求 1：Awesome 風格核心版面架構與側邊欄導航

**使用者故事：** 作為使用者，我希望有一個如 Awesome Mail 般清晰優雅的三欄式版面，包含完整的側邊欄導航，讓我能夠高效地瀏覽郵件、閱讀內容並使用 AI 功能。

#### 驗收標準

1. WHEN 應用程式啟動 THEN 系統 SHALL 顯示 Awesome 風格三欄版面（Sidebar / MessageList / ReadingPane）並使用 8pt 網格系統
2. WHEN 側邊欄顯示 THEN 系統 SHALL 包含完整的郵箱分類：Inbox、To-Do、Important、Updates、Promotions、Starred、Draft、Sent、Archive、Spam、Trash
3. WHEN 使用者點擊側邊欄項目 THEN 系統 SHALL 使用選中狀態（藍色背景）並更新郵件清單內容
4. WHEN 使用者點擊 AI 功能 THEN 系統 SHALL 顯示可開關的 AIDrawer（360-380px 寬度）並使用流暢的滑入動畫
5. WHEN 使用者調整視窗大小 THEN 系統 SHALL 保持 Sidebar 240-264px 可收合、內容欄 680-740px 的比例，並支援拖拽調整
6. WHEN 使用者切換深淺色主題 THEN 系統 SHALL 使用 EnhancedThemeManager 與 MacOSDesignSystem 保持視覺一致性
7. WHEN 使用者使用快捷鍵 ⌘K/⌘F/⌘N/⌘, THEN 系統 SHALL 正確響應對應功能並提供視覺回饋
8. WHEN 介面元素載入 THEN 系統 SHALL 使用 Awesome 風格的微妙陰影和圓角（12-14px）
9. WHEN 使用者 hover 互動元素 THEN 系統 SHALL 提供 150ms 的平滑過渡效果
10. WHEN 側邊欄項目顯示 THEN 系統 SHALL 使用適當的圖示（信封、星號、草稿等）和清晰的文字標籤

### 需求 2：Awesome 風格郵件清單與智慧分類

**使用者故事：** 作為使用者，我希望能夠透過 Awesome 風格的智慧分類和優雅的清單設計快速找到重要郵件，並使用進階搜尋功能精確定位內容。

#### 驗收標準

1. WHEN 使用者查看郵件清單 THEN 系統 SHALL 顯示 Awesome 風格的頭像/字母圈（32px 圓形）、主旨、摘要、徽章、附件圖示、時間，並使用適當的字體層次
2. WHEN 郵件未讀 THEN 系統 SHALL 以 SF Pro Semi-Bold 顯示主旨，已讀郵件使用 Regular 並降低 40% 對比度
3. WHEN 使用者 hover 郵件列 THEN 系統 SHALL 顯示 Awesome 風格的快速動作浮層（封存/刪除/標未讀/加星/釘選）並使用微妙的背景色變化
4. WHEN 使用者點擊分類 chips（Important/Updates/Promotions/All）THEN 系統 SHALL 正確過濾郵件清單並使用流暢的淡入淡出動畫
5. WHEN 使用者使用搜尋運算子（from:/subject:/has:attachment）THEN 系統 SHALL 解析並顯示 Awesome 風格的 chips 化條件（圓角膠囊設計）
6. WHEN 使用者在 trackpad 上左/右滑動 THEN 系統 SHALL 執行封存/刪除動作並提供視覺回饋和觸覺反饋
7. WHEN 清單超過 1,000 列 THEN 系統 SHALL 使用虛擬化渲染保持 60fps 順暢滾動
8. WHEN 郵件列高度 THEN 系統 SHALL 使用 56-64px 高度並保持 8pt 網格對齊

### 需求 3：閱讀體驗與安全指示

**使用者故事：** 作為使用者，我希望有清晰的郵件閱讀介面，能夠快速執行動作並了解郵件的安全狀態。

#### 驗收標準

1. WHEN 使用者選擇郵件 THEN 系統 SHALL 在 ReadingPane 顯示 MessageHeader（主旨 22-24px semi-bold）
2. WHEN 使用者點擊 Meta 區域 THEN 系統 SHALL 展開顯示 To/Cc/Bcc 資訊
3. WHEN 使用者使用快捷鍵 R/A/F/E/S/. THEN 系統 SHALL 執行對應動作（回覆/全部回覆/轉寄/封存/加星/更多）
4. WHEN 郵件包含 DKIM/SPF/DMARC 資訊 THEN 系統 SHALL 顯示對應的信任狀態指示
5. WHEN 郵件包含外部圖片 THEN 系統 SHALL 提供「載入外部圖片」切換與追蹤像素阻擋提示
6. WHEN 郵件內容過長 THEN 系統 SHALL 正確折疊引用內容
7. WHEN 內容欄寬度為 680-740px THEN 系統 SHALL 保持適當的閱讀體驗

### 需求 4：AI 功能整合

**使用者故事：** 作為使用者，我希望能夠使用 AI 功能來摘要郵件、生成待辦事項和草擬回覆。

#### 驗收標準

1. WHEN 使用者開啟 AIDrawer THEN 系統 SHALL 顯示建議 chips（Summarize / Generate to-do / Draft a reply）
2. WHEN 使用者點擊 AI 建議 chips THEN 系統 SHALL 觸發對應的 AI 功能
3. WHEN 使用者在 AI 輸入框按 ⌘Enter THEN 系統 SHALL 送出 AI 請求
4. WHEN AI 功能執行完成 THEN 系統 SHALL 在適當位置顯示結果
5. WHEN 使用者關閉 AIDrawer THEN 系統 SHALL 記住狀態偏好設定
6. WHEN 郵件需要安全警示 THEN 系統 SHALL 顯示 MessageBanner（info/warning/danger/security）

### 需求 5：Awesome 風格撰寫與生產力功能

**使用者故事：** 作為使用者，我希望能夠透過 Awesome 風格的優雅撰寫介面高效地撰寫郵件、管理待辦事項，並獲得 AI 協助。

#### 驗收標準

1. WHEN 使用者按 ⌘N THEN 系統 SHALL 開啟 Awesome 風格的底部抽屜式 Composer，使用深色背景和圓角設計
2. WHEN Composer 開啟 THEN 系統 SHALL 顯示 To、Cc Bcc、Subject 欄位，並在內容區域顯示 "Start typing or write with AI" 提示文字
3. WHEN 使用者在 Composer 輸入收件人 THEN 系統 SHALL 提供自動完成建議（依通訊錄/歷史寄件）
4. WHEN 使用者在 Composer 中按 Esc THEN 系統 SHALL 關閉 Composer 並保持背景郵件清單可見
5. WHEN 使用者在 Composer 中按 ⌘Enter THEN 系統 SHALL 送出郵件
6. WHEN 使用者撰寫郵件 THEN 系統 SHALL 自動儲存草稿
7. WHEN Composer 底部工具列顯示 THEN 系統 SHALL 包含 "Write with AI..." 按鈕和其他撰寫工具（格式化、附件等）
8. WHEN 使用者點擊 "Write with AI..." THEN 系統 SHALL 觸發 AI 協助撰寫功能
9. WHEN 使用者查看 To-Do 清單 THEN 系統 SHALL 顯示 Active/Done 切換與到期 chips
10. WHEN To-Do 項目關聯郵件 THEN 系統 SHALL 顯示 linkedEmailId 並可導回原郵件

### 需求 6：進階功能與操作

**使用者故事：** 作為使用者，我希望能夠批次處理郵件、使用進階搜尋，並透過拖放操作提高效率。

#### 驗收標準

1. WHEN 使用者選擇多封郵件 THEN 系統 SHALL 顯示批次工具列（封存/刪除/標記/加星）
2. WHEN 使用者右鍵點擊郵件 THEN 系統 SHALL 顯示上下文選單
3. WHEN 使用者拖放郵件到資料夾/標籤 THEN 系統 SHALL 執行移動操作
4. WHEN 使用者拖放附件 THEN 系統 SHALL 支援拖入/拖出操作
5. WHEN 使用者查看對話串 THEN 系統 SHALL 支援折疊/展開與快速跳至最新
6. WHEN 使用者按 ⌘K THEN 系統 SHALL 開啟 Command Palette 進行動作搜尋

### 需求 7：Awesome 風格帳號管理與個人化

**使用者故事：** 作為使用者，我希望能夠透過 Awesome 風格的優雅介面管理多個郵件帳號，並個人化我的使用體驗。

#### 驗收標準

1. WHEN 使用者點擊帳號選單 THEN 系統 SHALL 顯示 Awesome 風格的帳號選擇器，包含圓形頭像、使用者名稱、郵件地址和勾選標記
2. WHEN 帳號選擇器顯示 THEN 系統 SHALL 使用深色背景（#2C2C2E）、圓角卡片設計和微妙的邊框
3. WHEN 使用者切換帳號 THEN 系統 SHALL 更新郵件清單來源範圍並使用平滑的過渡動畫
4. WHEN 顯示 "All" 選項 THEN 系統 SHALL 顯示藍色使用者圖示和 "1 Email Accounts" 描述文字
5. WHEN 使用者建立 Smart Label THEN 系統 SHALL 顯示 "New Smart Label" 對話框，包含 Name 欄位（0/30 字數限制）、Label Prompt 文字區域（0/100 字數限制）和色彩選擇器
6. WHEN Smart Label 對話框顯示 THEN 系統 SHALL 提供多種顏色選項（藍、綠、橙、紅、灰、紫、粉等）並使用圓形色票設計
7. WHEN 使用者填寫 Smart Label 表單 THEN 系統 SHALL 即時顯示字數統計並在達到限制時阻止輸入
8. WHEN Smart Label 對話框開啟 THEN 系統 SHALL 使背景郵件清單變暗並保持可見
9. WHEN 使用者點擊 Cancel 或 Create THEN 系統 SHALL 關閉對話框並恢復背景亮度
10. WHEN Smart Label 建立完成 THEN 系統 SHALL 在 chips/側欄同步顯示並使用選定的顏色
7. WHEN 使用者調整偏好設定 THEN 系統 SHALL 持久化儲存狀態

### 需求 8：商業化與功能門檻

**使用者故事：** 作為使用者，我希望了解不同方案的功能限制，並能夠輕鬆升級到付費方案。

#### 驗收標準

1. WHEN 使用者達到功能使用限制 THEN 系統 SHALL 顯示升級提示對話框
2. WHEN 升級提示顯示 THEN 系統 SHALL 包含方案差異比較與付款導向
3. WHEN 使用者升級方案 THEN 系統 SHALL 即時刷新可用功能
4. WHEN 功能門檻觸發 THEN 系統 SHALL 在 AI chips、搜尋進階條件、規則引擎等處正確攔截
5. WHEN 使用量狀態更新 THEN 系統 SHALL 與後端 API（/subscriptions/status、/subscriptions/usage）同步

### 需求 9：無障礙與國際化

**使用者故事：** 作為使用者，我希望應用程式支援無障礙功能和多語言，讓所有人都能使用。

#### 驗收標準

1. WHEN 使用者使用螢幕閱讀器 THEN 系統 SHALL 提供完整的語義標籤與敘述
2. WHEN 使用者使用鍵盤導航 THEN 系統 SHALL 提供清楚的焦點環與正確的 Tab 序
3. WHEN 使用者啟用高對比模式 THEN 系統 SHALL 保持 AA+ 對比度標準
4. WHEN 系統顯示文字 THEN 系統 SHALL 使用現有 l10n 管線（繁中為基準，英/日為第二優先）
5. WHEN 使用者切換語言 THEN 系統 SHALL 正確顯示所有介面元素的翻譯

### 需求 10：Awesome 風格設定介面

**使用者故事：** 作為使用者，我希望有一個清晰易用的設定介面，讓我能夠管理帳號、自訂功能和調整應用程式偏好。

#### 驗收標準

1. WHEN 使用者開啟設定 THEN 系統 SHALL 顯示 Awesome 風格的設定視窗，包含左側導航欄和右側內容區域
2. WHEN 設定側邊欄顯示 THEN 系統 SHALL 包含：Account、Awesome Plus、Customize AI、Smart Filter、Notification、Inbox、Language、Appearance、Shortcut、Legal 等選項
3. WHEN 使用者點擊 Account 設定 THEN 系統 SHALL 顯示 Awesome Account 資訊（使用者名稱、郵件地址）和 Connected Email Accounts 列表
4. WHEN 帳號資訊顯示 THEN 系統 SHALL 提供 Sign Out 和 Delete Account 按鈕，使用適當的色彩區分（藍色/紅色）
5. WHEN Connected Email Accounts 顯示 THEN 系統 SHALL 列出所有已連接的郵件帳號，並提供管理功能
6. WHEN 設定項目包含切換開關 THEN 系統 SHALL 使用 Awesome 風格的 toggle 設計（如 Auto-Download Updates）
7. WHEN 使用者在設定間導航 THEN 系統 SHALL 使用平滑的過渡動畫
8. WHEN 設定視窗顯示 THEN 系統 SHALL 使用深色背景、圓角設計和適當的間距

### 需求 11：效能與穩定性

**使用者故事：** 作為使用者，我希望應用程式運行順暢，即使處理大量郵件也不會卡頓。

#### 驗收標準

1. WHEN 郵件清單超過 1,000 列 THEN 系統 SHALL 使用虛擬化渲染保持順暢滾動
2. WHEN 使用者輸入搜尋條件 THEN 系統 SHALL 使用防抖機制避免過度請求
3. WHEN 系統載入附件縮圖 THEN 系統 SHALL 使用快取機制提高效能
4. WHEN 動畫執行 THEN 系統 SHALL 保持 120-160ms 的過渡時間
5. WHEN 系統記錄日誌 THEN 系統 SHALL 使用台灣用語繁體中文輸出