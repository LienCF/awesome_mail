# 規格：批次 53 backend route env fake 基礎收斂

## 背景

backend `tests/unit/routes` 仍有 11 支測試大量依賴 `vi.fn()`、`vi.spyOn()` 與 inline env mock。這批先處理最容易共用同一套 fake 的 4 支路由測試：

- `awesome-mail/tests/unit/routes/metrics.test.ts`
- `awesome-mail/tests/unit/routes/logs.test.ts`
- `awesome-mail/tests/unit/routes/integrations.test.ts`
- `awesome-mail/tests/unit/routes/accounts.test.ts`

它們共同問題是：
- 直接在測試內組大量 `KV` / `D1` / `Durable Object` mock 結構
- 用 `vi.fn().mockResolvedValue()` 驅動簡單儲存與查詢流程
- 同一類 auth user lookup / KV store / route app setup 在各檔重複

## 目標

1. 建立 backend route 測試可共用的 hand-written Env / KV / D1 / DO fake。
2. 將上述 4 支 route 測試改成用手寫 fake、真實 JWT 與 Hono app 驅動。
3. 清除 batch 53 範圍內的 `vi.fn`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<`、`as Mock`。
4. 驗證 batch 53 targeted tests 與 `awesome-mail` `npm run quality:check` 通過。

## 範圍

- `awesome-mail/tests/helpers/route-env-fakes.ts`
- `awesome-mail/tests/unit/routes/metrics.test.ts`
- `awesome-mail/tests/unit/routes/logs.test.ts`
- `awesome-mail/tests/unit/routes/integrations.test.ts`
- `awesome-mail/tests/unit/routes/accounts.test.ts`

## 非目標

- `tests/unit/routes/ai.test.ts`
- `tests/unit/routes/auth.test.ts`
- `tests/unit/routes/oauth.test.ts`
- `tests/unit/routes/emails.test.ts`
- `tests/unit/routes/subscriptions*.test.ts`
- `tests/unit/routes/sync.test.ts`
- production route 邏輯改寫

## 驗收條件

1. batch 53 範圍檔案已清空上述 mock-heavy 關鍵字。
2. batch 53 targeted tests 全部通過。
3. `awesome-mail` `npm run quality:check` 通過。
