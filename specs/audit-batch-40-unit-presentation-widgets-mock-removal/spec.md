# Spec: 批次 40 unit presentation widgets mock 清理

## 背景

`awesome_mail_flutter/test/unit/presentation/widgets` 目前仍有 7 支測試依賴 `mockito`、`mocktail`、`MockBloc` 或 generated `.mocks.dart`。這些測試集中在 AI widget、sync widget、OAuth feature discovery 與 voice input button，屬於同一層的 UI 單元測試，適合在同一批次改成 hand-written fake / recorder。

## 目標

1. 將 batch 40 納入的 7 支 unit widget 測試改成 hand-written fake / recorder 驅動
2. 刪除對應 4 個 generated `.mocks.dart`
3. 以 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos` 驗證本批次收尾

## 範圍

- `awesome_mail_flutter/test/unit/presentation/widgets/ai/email_classification_widget_test.dart`
- `awesome_mail_flutter/test/unit/presentation/widgets/common/voice_input_button_test.dart`
- `awesome_mail_flutter/test/unit/presentation/widgets/email/ai_reply/ai_reply_suggestions_widget_test.dart`
- `awesome_mail_flutter/test/unit/presentation/widgets/oauth/oauth_feature_discovery_widget_test.dart`
- `awesome_mail_flutter/test/unit/presentation/widgets/reading_pane/reanalyze_button_test.dart`
- `awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_impl_test.dart`
- `awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_test.dart`

## 非目標

- 不修改 production widget 行為
- 不處理 `test/unit/core/security`、`test/unit/core/network` 或 backend mock-heavy 測試

## 驗證

1. `flutter test` 跑 batch 40 相關 7 支測試全部通過
2. `rg` 確認 `test/unit/presentation/widgets` 已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`、`MockBloc`
3. `flutter analyze --fatal-infos` 通過
