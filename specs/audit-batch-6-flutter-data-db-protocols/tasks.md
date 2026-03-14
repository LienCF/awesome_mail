> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 批次 6：Flutter Data database/protocols + domain 單元測試補全

## 任務清單

### Database Tables
- [x] T1: 為 `lib/data/database/connection/connection.dart` (5行) 撰寫單元測試 -已完成
- [x] T2: 為 `lib/data/database/connection/native.dart` (14行) 撰寫單元測試 -已完成
- [x] T3: 為 `lib/data/database/tables/accounts_table.dart` (35行) 撰寫單元測試 -已完成
- [x] T4: 為 `lib/data/database/tables/folders_table.dart` (40行) 撰寫單元測試 -已完成
- [x] T5: 為 `lib/data/database/tables/attachments_table.dart` (43行) 撰寫單元測試 -已完成
- [x] T6: 為 `lib/data/database/tables/drafts_table.dart` (53行) 撰寫單元測試 -已完成
- [x] T7: 為 `lib/data/database/tables/sync_metadata_table.dart` (59行) 撰寫單元測試 -已完成
- [x] T8: 為 `lib/data/database/tables/emails_table.dart` (84行) 撰寫單元測試 -已完成

### Domain Entities
- [x] T9: 為 `lib/domain/entities/email_address.dart` (56行) 撰寫單元測試 -已完成
- [x] T10: 為 `lib/domain/entities/attachment.dart` (72行) 撰寫單元測試 -已完成
- [x] T11: 為 `lib/domain/repositories/email_repository.dart` (122行) 撰寫單元測試 -已完成

### Protocols
- [x] T12: 為 `lib/data/protocols/jmap/jmap_client.dart` (430行) 撰寫單元測試 -已完成
- [x] T13: 為 `lib/data/protocols/caldav/caldav_client.dart` (592行) 撰寫單元測試 -已完成
- [x] T14: 為 `lib/data/protocols/carddav/carddav_client.dart` (706行) 撰寫單元測試 -已完成
- [x] T15: 為 `lib/data/protocols/exchange/ews_client.dart` (787行) 撰寫單元測試 -已完成
