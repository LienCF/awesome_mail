# Spec: 批次 35 presentation bloc foundation mock 清理

## 背景

batch 34 已清空 `awesome_mail_flutter/test/integration` 的 mock-heavy 測試。重新掃描後，Flutter 下一個剩餘主群組是 `awesome_mail_flutter/test/unit/presentation/blocs`，其中第一組基礎檔案 `4` 支為：

- `bloc_factory_test.dart`
- `bloc_manager_test.dart`
- `email_sync/email_sync_cubit_test.dart`
- `mailbox/mailbox_action_cubit_test.dart`

另外同群組目前還有 `1` 個直接對應的 generated `.mocks.dart`：

- `bloc_manager_test.mocks.dart`

## 問題陳述

這批測試目前有四個主要問題：

1. `bloc_factory_test.dart` 只驗證 `BlocFactory` 從 `GetIt` 取出指定型別，卻用 `mocktail` 建立一整排 `Mock implements BlocType`，導致測試只是在驗證框架替身。
2. `bloc_manager_test.dart` 用 `mockito` 加 generated mocks 驗證 logger 與 lifecycle 呼叫，維護成本高，而且 `.mocks.dart` 是多餘依賴。
3. `email_sync/email_sync_cubit_test.dart` 對 `EmailSynchronizer` 與 `SyncStateManager` 的依賴全交給 `mocktail`，測試本身只驗證 state 轉移，適合改成手寫 synchronizer fake / state gate fake。
4. `mailbox/mailbox_action_cubit_test.dart` 對 `EmailRepository` 的依賴是狹窄的 action API，使用 mock framework 不符合 Detroit School 偏好，也讓行為驗證散在 `verify(...)`。

## 使用者故事

### US1: bloc 基礎測試改用手寫 fake

作為維護者，我們希望基礎 bloc / cubit 測試改用手寫 interface fake 或 recorder，直接驗證回傳型別、呼叫紀錄與 state 變化。

#### 驗收條件

1. `bloc_factory_test.dart` 不再使用 `mocktail`，改用手寫 fake bloc 型別註冊到 `GetIt`。
2. `bloc_manager_test.dart` 不再使用 `mockito` 或 generated `.mocks.dart`，改用手寫 logger / lifecycle recorder。
3. `email_sync/email_sync_cubit_test.dart` 與 `mailbox/mailbox_action_cubit_test.dart` 不再依賴 `mocktail`。

### US2: 以真實行為驗證取代框架式 verify

作為維護者，我們希望這批測試直接驗證 fake 的 recorded calls 與實際 state，而不是把 assertion 綁在 mock framework API。

#### 驗收條件

1. `bloc_manager_test.dart` 直接驗證 logger 訊息與 lifecycle recorder 狀態。
2. `email_sync/email_sync_cubit_test.dart` 直接驗證 synchronizer 呼叫紀錄、state gate 與發出的 state。
3. `mailbox/mailbox_action_cubit_test.dart` 直接驗證 repository action 呼叫紀錄與錯誤注入。

### US3: batch 35 範圍內的 mock framework 依賴清空

作為維護者，我們希望 batch 35 的第一組 bloc 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`。

#### 驗收條件

1. 這 `4` 支測試與其支援 fake 已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`。
2. `bloc_manager_test.mocks.dart` 已刪除，且 codebase 無殘留參照。
3. targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。

## 非目標

- 不修改 `BlocFactory`、`EmailSyncCubit`、`MailboxActionCubit` 的 production 公開 API。
- 不在本批次處理 `test/unit/presentation/blocs` 其餘 `7` 支測試。
- 不處理 `test/unit/presentation/pages` 或 backend mock-heavy 測試。

## 成功指標

- 這 `4` 支 bloc 測試全部改由手寫 fake / recorder 驅動。
- `test/unit/presentation/blocs` 這個群組的 mock-heavy 數量在本批次後持續下降。
- batch 35 targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。
