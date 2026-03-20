> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 16 page / handler coverage 對齊

## 技術策略

1. 以既有測試建立 coverage 對映：
   - `account_setup_page_test.dart` 對應 account setup widgets。
   - `home_page_test.dart` / `macos_home_page_test.dart` 對應 home widgets。
   - `mailbox_handlers_test.dart` 對應 5 個 private mailbox handlers。
   - `settings_page_test.dart` 加上各 settings 子頁測試，對應 7 個 private settings sections。
2. 執行這批 targeted tests，確認 coverage 依據成立。
3. 更新 `tdd-audit-report.md` 與 batch 16 `tasks.md`，移除 17 個假陽性並下修 Flutter 缺測數。

## 分組實作

### A. Account setup / home composition

- `awesome_mail_flutter/lib/presentation/pages/account_setup/widgets/setup_error_widget.dart`
- `awesome_mail_flutter/lib/presentation/pages/account_setup/widgets/protonmail_setup_widget.dart`
- `awesome_mail_flutter/lib/presentation/pages/account_setup/widgets/enterprise_setup_widget.dart`
- `awesome_mail_flutter/lib/presentation/pages/home/widgets/home_mailbox_view.dart`
- `awesome_mail_flutter/lib/presentation/widgets/home/home_toolbar.dart`

### B. Mailbox handlers

- `awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_folder_handlers.dart`
- `awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_batch_handlers.dart`
- `awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_label_handlers.dart`
- `awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_email_handlers.dart`
- `awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_sync_handlers.dart`

### C. Settings sections

- `awesome_mail_flutter/lib/presentation/pages/settings/_settings_appearance_section.dart`
- `awesome_mail_flutter/lib/presentation/pages/settings/_settings_ai_section.dart`
- `awesome_mail_flutter/lib/presentation/pages/settings/_settings_notification_section.dart`
- `awesome_mail_flutter/lib/presentation/pages/settings/_settings_account_section.dart`
- `awesome_mail_flutter/lib/presentation/pages/settings/_settings_shared_widgets.dart`
- `awesome_mail_flutter/lib/presentation/pages/settings/_settings_legal_section.dart`
- `awesome_mail_flutter/lib/presentation/pages/settings/_settings_sync_section.dart`

## 驗證策略

- `flutter test test/unit/presentation/pages/account_setup/account_setup_page_test.dart test/widget/presentation/pages/account_setup/account_setup_page_test.dart test/widget/presentation/pages/home/home_page_test.dart test/widget/presentation/pages/home/macos_home_page_test.dart test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart test/widget/presentation/pages/settings/settings_page_test.dart test/widget/presentation/pages/settings/account_settings_page_test.dart test/widget/presentation/pages/settings/appearance_settings_page_test.dart test/widget/presentation/pages/settings/ai_settings_page_test.dart test/widget/presentation/pages/settings/notification_settings_page_test.dart test/widget/presentation/pages/settings/sync_settings_page_test.dart test/widget/presentation/pages/settings/about_page_test.dart`
- 更新 `tdd-audit-report.md` 與 batch 16 `tasks.md`
