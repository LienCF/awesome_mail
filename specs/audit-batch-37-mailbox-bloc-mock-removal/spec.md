# Spec: 批次 37 mailbox bloc mock 清理

## 背景

batch 36 已把 `test/unit/presentation/blocs` 中較小的 `5` 支核心測試與 `3` 個 generated `.mocks.dart` 清掉。重新掃描後，這個群組只剩下 `2` 支大型 mailbox 測試仍命中 mock-heavy 規則：

- `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_bloc_test.dart`
- `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart`

這兩支測試共用幾乎相同的依賴矩陣，目前都靠 `mocktail` 大量 `when(...)` / `verify(...)` 驅動。專案內已經有 `service_layer_fakes.dart`、`repository_dependency_fakes.dart`、`data_service_fakes.dart` 等可複用手寫替身，適合在這批收斂成 mailbox 專用 recorder / fake。

## 問題陳述

這批測試目前有四個主要問題：

1. `mailbox_bloc_test.dart` 與 `mailbox_handlers_test.dart` 各自定義一整排 `Mock implements ...`，setup 幾乎重複，維護成本極高。
2. 大量 assertion 綁在 `verify(...)`，實際想驗證的是 mailbox state 轉移、cache metadata 更新、下載與同步 side effects。
3. 依賴矩陣雖大，但多數只需要 recorder / in-memory 行為，不需要動態 mock framework。
4. 這兩支測試不清掉，`test/unit/presentation/blocs` 群組就無法真正收尾，後續審計仍會把 bloc 層視為未完成。

## 使用者故事

### US1: mailbox bloc 測試改用手寫 fake

作為維護者，我們希望 mailbox bloc 與 handler 測試改用手寫 recorder、stream fake 與 in-memory repository / service fake，直接驗證 state 與 side effects。

#### 驗收條件

1. `mailbox_bloc_test.dart` 不再使用 `mocktail`。
2. `mailbox_handlers_test.dart` 不再使用 `mocktail`。
3. 兩支測試可共用 mailbox 專用 dependency fake，而不是各自重複 setup。

### US2: 用 recorded calls 驗證 mailbox 行為

作為維護者，我們希望 mailbox 測試直接驗證 cache 更新、sync 觸發、folder/account 選取、download 觸發與 repository 呼叫紀錄。

#### 驗收條件

1. cache / metadata / notifier / cubit side effects 直接由 recorder 驗證，不再透過 `verify(...)`。
2. 測試繼續覆蓋 mailbox state、API pagination 與 handler 分支行為。
3. 新的 fake 設計能支撐兩支測試共用。

### US3: batch 37 範圍內的 mock framework 依賴清空

作為維護者，我們希望 `test/unit/presentation/blocs/mailbox` 這個子群組在本批次後完全不再命中 `mocktail`、`extends Mock` 或 `.mocks.dart`。

#### 驗收條件

1. 這 `2` 支 mailbox 測試與其支援 fake 已無 `mocktail`、`extends Mock`、`.mocks.dart`。
2. targeted tests、搜尋驗證與 `flutter analyze --fatal-infos` 通過。
3. `test/unit/presentation/blocs` 群組在審計快照中降為 `0`。

## 非目標

- 不修改 `MailboxBloc` production 公開 API。
- 不在本批次處理 `test/unit/presentation/pages` 或其他 widget/page 群組。
- 不處理 backend mock-heavy 測試。

## 成功指標

- `mailbox_bloc_test.dart` 與 `mailbox_handlers_test.dart` 全部改為 hand-written fake / recorder 驅動。
- `test/unit/presentation/blocs` 群組在本批次完成後清為 `0`。
- batch 37 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos` 通過。
