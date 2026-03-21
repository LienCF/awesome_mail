# Spec: 批次 36 presentation bloc core mock 清理

## 背景

batch 35 已清掉 `awesome_mail_flutter/test/unit/presentation/blocs` 的第一組基礎測試，Flutter mock-heavy 檔案數降到 `104`。同一群組剩餘的較小主測試檔共有 `5` 支，另外仍有 `3` 個直接對應的 generated `.mocks.dart`：

- `ai/ai_bloc_test.dart`
- `email_sync_cubit_test.dart`
- `search/search_bloc_test.dart`
- `state_persistence_test.dart`
- `sync/sync_bloc_test.dart`
- `ai/ai_bloc_test.mocks.dart`
- `state_persistence_test.mocks.dart`
- `sync/sync_bloc_test.mocks.dart`

`mailbox/mailbox_bloc_test.dart` 與 `mailbox/mailbox_handlers_test.dart` 明顯更大，後續會獨立成下一批處理，避免把一個批次做成不可驗證的大包。

## 問題陳述

這批測試目前有五個主要問題：

1. `ai_bloc_test.dart` 雖然驗證的是 `AIBloc` 的狀態流轉，但依賴 `mockito` generated mocks，assertion 綁在 `verify(...)` 與 generated 類別。
2. `email_sync_cubit_test.dart` 是舊路徑測試，僅驗證 `historyExpired` 行為，卻仍使用 `mocktail` 取代狹窄的 `EmailSynchronizer` / `SyncStateManager` 依賴。
3. `search/search_bloc_test.dart` 用 `mocktail` 模擬 repository、service 與 logger，測試其實只需要可配置的查詢回應與儲存紀錄。
4. `state_persistence_test.dart` 以 `mockito` 驗證 `AuthBloc` 的持久化行為，導致 `AuthService`、`StatePersistenceService`、`DeviceIdService` 與 `Logger` 都被 generated mock 綁住。
5. `sync/sync_bloc_test.dart` 主要是在驗證 `SyncBloc` 對 `SyncService` 回傳結果與狀態串流的轉換規則，使用 generated mock 成本過高。

## 使用者故事

### US1: 核心 bloc 測試改用手寫 fake

作為維護者，我們希望這批核心 bloc / cubit 測試改用手寫 fake、stub 與 recorder，直接驗證狀態轉移與真實呼叫紀錄。

#### 驗收條件

1. `ai_bloc_test.dart` 不再使用 `mockito` 或 generated `.mocks.dart`。
2. `email_sync_cubit_test.dart` 與 `search/search_bloc_test.dart` 不再依賴 `mocktail`。
3. `state_persistence_test.dart` 與 `sync/sync_bloc_test.dart` 不再依賴 `mockito` 或 generated `.mocks.dart`。

### US2: 以 recorder / fake 驗證行為

作為維護者，我們希望 assertion 直接落在 hand-written fake 的 recorded calls、儲存資料與狀態值，而不是 mock framework API。

#### 驗收條件

1. `AIBloc` 測試直接驗證 AI service / repository / logger / intent service 的 recorded calls 與結果注入。
2. `SearchBloc`、`SyncBloc`、`AuthBloc` 持久化測試直接驗證假服務回傳、儲存內容與 logger 紀錄。
3. `email_sync_cubit_test.dart` 直接驗證 synchronizer 呼叫與 history expired 狀態。

### US3: batch 36 範圍內的 mock framework 依賴清空

作為維護者，我們希望 batch 36 這一組 bloc 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`。

#### 驗收條件

1. 這 `5` 支測試與其支援 fake 已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`。
2. `ai_bloc_test.mocks.dart`、`state_persistence_test.mocks.dart`、`sync_bloc_test.mocks.dart` 已刪除，且 codebase 無殘留參照。
3. targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。

## 非目標

- 不修改 `AIBloc`、`SearchBloc`、`AuthBloc`、`SyncBloc`、`EmailSyncCubit` 的 production 公開 API。
- 不在本批次處理 `mailbox/mailbox_bloc_test.dart` 或 `mailbox/mailbox_handlers_test.dart`。
- 不處理 `test/unit/presentation/pages` 或 backend mock-heavy 測試。

## 成功指標

- 這 `5` 支 bloc / cubit 測試全部改由手寫 fake / recorder 驅動。
- `test/unit/presentation/blocs` 這個群組的 mock-heavy 數量在本批次後繼續下降。
- batch 36 targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。
