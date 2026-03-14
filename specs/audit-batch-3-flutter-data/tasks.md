> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 批次 3：Flutter Data 服務和 Repository 單元測試補全

審計發現以下 12 個關鍵檔案缺少測試。

## 任務清單

- [x] T1: 為 `lib/data/services/email_detail_update_notifier.dart` (22行) 撰寫單元測試 -6 個測試通過
- [x] T2: 為 `lib/data/providers/gmail/gmail_oauth_service.dart` (53行) 撰寫單元測試 -6 個測試通過
- [x] T3: 為 `lib/data/services/email_list_update_notifier.dart` (74行) 撰寫單元測試 -11 個測試通過
- [x] T4: 為 `lib/data/services/vector_search_service.dart` (87行) 撰寫單元測試 -10 個測試通過
- [x] T5: 為 `lib/data/services/email_search_service.dart` (103行) 撰寫單元測試 -16 個測試通過
- [x] T6: 為 `lib/data/providers/gmail/gmail_token_refresh_manager.dart` (117行) 撰寫單元測試 -16 個測試通過
- [x] T7: 為 `lib/data/services/email_flags_service.dart` (172行) 撰寫單元測試 -15 個測試通過
- [x] T8: 為 `lib/data/services/security/security_service.dart` (269行) 撰寫單元測試 -17 個測試通過
- [x] T9: 為 `lib/data/providers/protonmail/protonmail_bridge_detector.dart` (361行) 撰寫單元測試 -18 個測試通過
- [x] T10: 為 `lib/data/services/productivity_service.dart` (384行) 撰寫單元測試 -18 個測試通過
- [x] T11: 為 `lib/data/providers/gmail/gmail_oauth_service_real.dart` (450行) 撰寫單元測試 -19 個測試通過
- [x] T12: 為 `lib/data/repositories/email_repository_impl.dart` (1403行) 撰寫單元測試 -36 個測試通過
