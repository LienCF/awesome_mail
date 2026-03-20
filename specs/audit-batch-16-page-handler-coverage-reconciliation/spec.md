# Spec: 批次 16 page / handler coverage 對齊

## 背景

批次 14、15 已經先把 state 與 helper 類的假陽性清掉，Flutter 缺測數從 46 檔降到 31 檔。剩下名單裡還有一組明顯屬於「由頁面測試或整合型 bloc 測試間接覆蓋」的檔案：

- account setup widgets：
  - `setup_error_widget.dart`
  - `protonmail_setup_widget.dart`
  - `enterprise_setup_widget.dart`
- home widgets：
  - `home_mailbox_view.dart`
  - `home_toolbar.dart`
- mailbox handlers：
  - `_mailbox_folder_handlers.dart`
  - `_mailbox_batch_handlers.dart`
  - `_mailbox_label_handlers.dart`
  - `_mailbox_email_handlers.dart`
  - `_mailbox_sync_handlers.dart`
- settings sections：
  - `_settings_appearance_section.dart`
  - `_settings_ai_section.dart`
  - `_settings_notification_section.dart`
  - `_settings_account_section.dart`
  - `_settings_shared_widgets.dart`
  - `_settings_legal_section.dart`
  - `_settings_sync_section.dart`

這些檔案多半是 private section、page composition 或 extension handlers，本來就不一定用一對一檔名建立測試；若報告不做對齊，缺測估算仍會明顯失真。

## 問題陳述

目前審計報告把 17 個已被頁面 / bloc 測試覆蓋的檔案列為缺測，造成：

1. Flutter 缺測數高估。
2. 後續真正缺測的 debug page、routing、generated / example 檔案被埋在噪音中。

## 使用者故事

### US1: page / handler 類缺測名單與真實測試對齊

作為維護者，我們希望 page composition 與 private handler 檔案只在真的沒有 coverage 時才列為缺測，讓剩餘名單聚焦在真正要補測的風險項目。

#### 驗收條件

1. 上述 17 個檔案從缺測清單移除。
2. 對應的既有測試重新執行並通過。
3. Flutter 缺測總數依這次校正再次下修。

## 非目標

- 不處理 debug pages、`app_router.dart`、`firebase_options.dart`、generated DI / example 檔案。
- 不新增 production 程式碼。
- 不處理 batch 9 mock-heavy 測試清理。

## 成功指標

- 17 個 page / handler 類假陽性從報告移除。
- 對應 targeted tests 通過。
- `tdd-audit-report.md` 的 Flutter 缺測數反映最新校正結果。
