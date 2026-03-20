> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 18 Flutter 最後直接缺測收尾

## 技術策略

1. 先以紅燈方式執行不存在的新測試檔，確認這批直接缺測尚未被覆蓋。
2. 新增四組測試：
   - `maybe_selection_area_test.dart` 驗證選取區域包裝行為
   - `adaptive_widgets_test.dart` 驗證 mobile / desktop 分支與互動
   - `debug_pages_test.dart` 驗證 debug 頁面可建構的部分與 debug fixture 內容
   - `app_router_test.dart` 驗證 unknown route、protected loading 與 search route accountId 傳遞
3. 對於 WebView debug 頁面，不直接在 widget test 建立 `InAppWebView` 平台視圖，而是針對頁面內可直接驗證的 HTML fixture 與 shell 行為建立測試，避免把 plugin 測試問題混入本批次。
4. `AIDiagnosticsPage` 以 fake `FoundationModelClientWithLifecycle` 驅動 client lifecycle stream，避免依賴真實裝置端 plugin。
5. 完成後更新 `tdd-audit-report.md` 與 batch 18 `tasks.md`，將 Flutter 缺測數下修到 0。

## 驗證策略

- `flutter test test/widget/shared/widgets/maybe_selection_area_test.dart`
- `flutter test test/widget/presentation/widgets/adaptive/adaptive_widgets_test.dart`
- `flutter test test/widget/presentation/pages/debug/debug_pages_test.dart`
- `flutter test test/widget/core/routing/app_router_test.dart`
- `flutter analyze --fatal-infos`
