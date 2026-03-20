# Spec: 批次 12 parser / sync / pagination 控制流清理

## 背景

批次 8 與批次 11 已先後清掉高優先 polling 迴圈，以及局部有界 `while` 與 traversal 控制流。目前專案內剩餘的 `while` / `do-while` 已收斂到 4 個高耦合檔案，分別位於 parser、同步重試與 Gmail 分頁流程：

- `awesome_mail_flutter/lib/data/protocols/imap/imap_response_parser.dart`
- `awesome_mail_flutter/lib/core/sync/email_synchronizer.dart`
- `awesome_mail_flutter/lib/data/repositories/gmail_repository.dart`
- `awesome-mail/src/jobs/base-job.ts`

這些控制流雖然不像 polling 那樣持續空轉，但仍違反專案的「避免 while loop」規範，而且集中在資料解析與同步核心路徑，一旦不拆批次直接修改，風險會過高。

## 問題陳述

目前剩餘違規有兩種型態：

1. 字串 parser 狀態機：`imap_response_parser.dart`
2. retry / pagination 控制流：`email_synchronizer.dart`、`gmail_repository.dart`、`base-job.ts`

如果不清掉，`while` 類違規仍無法歸零，也會讓後續對同步正確性與 parser 行為的回歸測試維持在較脆弱的狀態。

## 使用者故事

### US1: IMAP parser 狀態機不再使用 `while`

作為維護者，我們希望 envelope 與地址清單解析流程改成顯式遞迴或索引前進 helper，讓 parser 行為更容易推導與測試。

#### 驗收條件

1. `imap_response_parser.dart` 不再使用 `while`。
2. quoted string、巢狀括號、地址清單與 atom parsing 行為維持不變。
3. 相關 parser 測試全部通過。

### US2: retry 與 sync checkpoint 流程不再使用 `while`

作為維護者，我們希望資料庫寫入重試與 backend job retry 改成明確的遞迴或 attempt helper，避免狀態變數與 break 條件交錯。

#### 驗收條件

1. `email_synchronizer.dart` 的 historyId 儲存重試不使用 `while`。
2. `base-job.ts` 的 retry 主流程不使用 `while`。
3. 失敗重試次數、錯誤回傳與 timeout 行為不變。

### US3: Gmail 全量同步與 reconciliation 分頁不再使用 `do/while`

作為維護者，我們希望 Gmail 分頁同步改成遞迴或明確的 page helper，讓 page token 推進、部分失敗與斷點續跑邏輯更可讀。

#### 驗收條件

1. `gmail_repository.dart` 的兩段 `do/while` 分頁流程都被移除。
2. page token 推進、partial failure、刪除階段與進度回報維持不變。
3. 相關 repository / sync 測試全部通過。

## 非目標

- 不處理 Detroit School mock-heavy 測試清理。
- 不處理缺少測試的 Flutter / Python 維護碼。
- 不引入新同步功能或變更對外 API。

## 成功指標

- `rg -n "\\bwhile\\s*\\(|\\bdo\\s*\\{" awesome-mail/src awesome_mail_flutter/lib` 不再命中。
- backend `quality:check`、Flutter `analyze` 與變更相關測試通過。
- `tdd-audit-report.md` 更新後，`while` / `do-while` 類違規歸零。
