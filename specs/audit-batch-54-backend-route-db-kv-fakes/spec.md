# 規格：批次 54 backend route DB / KV fake 延伸收斂

## 背景

batch 53 已先把小型 route 測試的 Env / KV / D1 / DO fake 基礎立起來，但 backend route 測試仍有一組以 DB / KV 狀態流程為主的 mock-heavy 檔案尚未清理：

- `awesome-mail/tests/unit/routes/emails.test.ts`
- `awesome-mail/tests/unit/routes/subscriptions-coverage.test.ts`
- `awesome-mail/tests/unit/routes/subscriptions.test.ts`
- `awesome-mail/tests/unit/routes/sync.test.ts`

這批問題主要是：
- 以 `vi.fn().mockResolvedValue()` 疊出多段 D1 查詢與 KV 狀態
- 依賴 `prepare.mockImplementation()` 與呼叫次數切換行為
- `sync.test.ts` 透過 module mock 攔截 crypto 工具

## 目標

1. 延伸 route helper，使其可表達 email / subscription / sync 類測試需要的 D1 / KV 狀態與查詢紀錄。
2. 將上述 4 支 route 測試改成真實 JWT、hand-written DB / KV fake，並盡可能走真實 crypto 流程。
3. 清除 batch 54 範圍內的 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<`、`as Mock`。
4. 驗證 batch 54 targeted tests 與 `awesome-mail` `npm run quality:check` 通過。

## 範圍

- `awesome-mail/tests/helpers/route-env-fakes.ts`
- `awesome-mail/tests/unit/routes/emails.test.ts`
- `awesome-mail/tests/unit/routes/subscriptions-coverage.test.ts`
- `awesome-mail/tests/unit/routes/subscriptions.test.ts`
- `awesome-mail/tests/unit/routes/sync.test.ts`

## 非目標

- `tests/unit/routes/auth.test.ts`
- `tests/unit/routes/oauth.test.ts`
- `tests/unit/routes/ai.test.ts`
- production route 邏輯改寫

## 驗收條件

1. batch 54 範圍檔案已清空上述 mock-heavy 關鍵字。
2. batch 54 targeted tests 全部通過。
3. `awesome-mail` `npm run quality:check` 通過。
