# Spec: 批次 39 widget presentation widgets mock 清理

## 背景

batch 38 已清空 test/unit/presentation/pages 群組。重新掃描後，Flutter 剩餘最大群組轉為 test/widget/presentation/widgets，目前命中的 13 個結果中有 3 個是 generated .mocks.dart，實際要改的是 10 支 widget 測試：

- awesome_mail_flutter/test/widget/presentation/widgets/ai/awesome_ai_drawer_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/ai/email_summary_widget_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/ai/entity_extraction/entity_extraction_widget_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/email/attachments/download_manager_button_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/email/reading_pane/email_summary_panel_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/email/reading_pane/message_meta_tool_events_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/macos/macos_preferences_dialog_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/oauth_migration_widget_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/oauth_onboarding_widget_test.dart
- awesome_mail_flutter/test/widget/presentation/widgets/subscription/feature_gate_test.dart

這批測試主要落在 widget 層，涉及 bloc listener、AI service、oauth flow、subscription gate 與 reading pane 互動。專案內已有 page/widget 用的 bloc fake、service fake、settings fake，可以進一步組合成 widget 專用 harness。

## 問題陳述

1. 這批 widget 測試仍混用 mockito、mocktail 與 generated mocks，維護成本高。
2. 多數測試真正想驗證的是 widget state、callback、dialog/snackbar、bloc 事件與 service side effect，不需要動態 mock framework。
3. test/widget/presentation/widgets 若不清掉，Flutter 剩餘 mock-heavy 最大群組無法收斂。

## 使用者故事

### US1: widget 測試改用手寫 fake / recorder

作為維護者，我們希望 AI widget、reading pane、oauth/subscription、macOS dialog 測試改用 hand-written fake / recorder，直接驗證 widget 行為。

#### 驗收條件

1. 上述 10 支測試不再使用 mockito、mocktail、MockBloc 或 @GenerateMocks。
2. 測試直接驗證 bloc/service recorder、callback、畫面輸出與互動結果。
3. 可重用的 widget fake / harness 能支撐同群組多支測試。

### US2: batch 39 範圍內的 generated mocks 清空

作為維護者，我們希望 test/widget/presentation/widgets 在本批次後不再殘留 batch 39 範圍內的 generated .mocks.dart 與相關參照。

#### 驗收條件

1. batch 39 涵蓋的 .mocks.dart 檔案可刪除。
2. targeted tests、搜尋驗證與 flutter analyze --fatal-infos 通過。
3. test/widget/presentation/widgets 群組在審計快照中清為 0。

## 非目標

- 不修改 production widget 的公開 API。
- 不在本批次處理 test/unit/presentation/widgets 或 backend 測試。

## 成功指標

- 10 支 widget 測試改為 hand-written fake / recorder 驅動。
- test/widget/presentation/widgets 群組完成後降為 0。
- batch 39 targeted tests、搜尋驗證與 flutter analyze --fatal-infos 通過。
