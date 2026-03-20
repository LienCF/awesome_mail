> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 15 helper coverage 對齊

## 技術策略

1. 先確認 9 個 helper 檔各自對應的測試檔存在。
2. 執行這 9 個 helper 的 targeted tests，確認報告要移除的項目都有實際 coverage。
3. 更新 `tdd-audit-report.md` 與 batch 15 `tasks.md`，移除這批假陽性並下修 Flutter 缺測總數。
4. 若全量 `flutter test` 在背景執行期間出現失敗，再把該失敗納入後續修正。

## 分組實作

### A. Repository helper coverage 對齊

- `awesome_mail_flutter/lib/data/repositories/_email_query_operations.dart`
- `awesome_mail_flutter/lib/data/repositories/_email_merge_helpers.dart`
- `awesome_mail_flutter/lib/data/repositories/_email_save_operations.dart`
- `awesome_mail_flutter/lib/data/repositories/_email_delete_operations.dart`

### B. Foundation helper coverage 對齊

- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_prompt_utils.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_sanitizer.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_security.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_core.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_summary.dart`

## 驗證策略

- `flutter test test/unit/data/repositories/email_query_operations_test.dart test/unit/data/repositories/email_merge_helpers_test.dart test/unit/data/repositories/email_save_operations_test.dart test/unit/data/repositories/email_delete_operations_test.dart test/unit/data/providers/foundation/foundation_ai_provider_prompt_utils_test.dart test/unit/data/providers/foundation/foundation_ai_provider_sanitizer_test.dart test/unit/data/providers/foundation/foundation_ai_provider_security_test.dart test/unit/data/providers/foundation/foundation_ai_provider_core_test.dart test/unit/data/providers/foundation/foundation_ai_provider_summary_test.dart`
- 更新 `tdd-audit-report.md` 與 batch 15 `tasks.md`
