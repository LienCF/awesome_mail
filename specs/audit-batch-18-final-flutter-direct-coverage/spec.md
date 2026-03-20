# Spec: 批次 18 Flutter 最後直接缺測收尾

## 背景

批次 17 完成後，Flutter 缺測清單還剩 9 檔，全部都是先前已從假陽性名單裡清出來的真實缺口：

- `awesome_mail_flutter/lib/presentation/pages/debug/ai_diagnostics_page.dart`
- `awesome_mail_flutter/lib/presentation/pages/debug/test_resizable_layout.dart`
- `awesome_mail_flutter/lib/presentation/pages/debug/scrollable_webview_test_page.dart`
- `awesome_mail_flutter/lib/presentation/pages/debug/resizable_layout_test_page.dart`
- `awesome_mail_flutter/lib/presentation/pages/debug/webview_test_page.dart`
- `awesome_mail_flutter/lib/presentation/pages/debug/complex_email_test_page.dart`
- `awesome_mail_flutter/lib/presentation/widgets/adaptive/adaptive_widgets.dart`
- `awesome_mail_flutter/lib/shared/widgets/maybe_selection_area.dart`
- `awesome_mail_flutter/lib/core/routing/app_router.dart`

這一批已經不是 generated、barrel、example 或間接覆蓋的假陽性，而是實際缺少直接測試的 UI / 路由 / debug 入口。

## 問題陳述

若不把這 9 檔補上直接測試，Flutter 缺測清單就無法歸零，整個 batch 10 也無法真正關帳。這些檔案雖多為 debug / shell / routing 類入口，但仍承擔了路由分流、選取區域包裝、平台自適應分支與診斷頁互動等實際行為。

## 使用者故事

### US1: Flutter 最後直接缺測檔案可被最小但真實的測試驗證

作為維護者，我們希望剩餘的 debug page、adaptive widget、selection wrapper 與 router，都有最小可驗證的直接測試，讓缺測清單歸零。

#### 驗收條件

1. `MaybeSelectionArea` 有 widget 測試驗證有無上層 `SelectionContainer` 的包裝行為。
2. `AdaptiveWidgets` 有直接測試驗證主要 mobile 分支互動與至少一個 desktop 分支。
3. debug pages 有直接測試或 smoke test，至少涵蓋：
   - `AIDiagnosticsPage` 的 tab / copy / client lifecycle 顯示
   - `TestApp` 與 `ResizableLayoutTestPage` 的基本建構與切換互動
   - `ScrollableWebViewTestPage`、`WebViewTestPage`、`ComplexEmailTestPage` 的 debug HTML fixture 輸出
4. `AppRouter` 有 widget 測試驗證：
   - unknown route 進入 `NotFoundPage`
   - protected route 在 `AuthLoading` 時顯示載入中
   - protected search route 會建立 `SearchPage` 並傳遞 `accountId`
5. `flutter analyze --fatal-infos` 與本批次相關測試全部通過。

## 非目標

- 不處理 Python 缺測與 generated 假陽性。
- 不重寫 `EmailScrollableWebView` 本體或 WebView plugin 測試策略。
- 不處理 mock-heavy 測試批次。

## 成功指標

- Flutter 剩餘缺測數從 9 檔降到 0 檔。
- 本批次新增的直接測試全部通過。
- `tdd-audit-report.md` 不再列出這 9 個 Flutter 檔案。
