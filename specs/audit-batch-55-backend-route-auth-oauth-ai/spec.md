# 規格：批次 55 backend route auth / oauth / ai fake 收斂

## 背景

batch 54 已把 backend route 中偏 DB / KV 狀態型的 mock-heavy 測試清掉，但 `tests/unit/routes` 還剩最後 3 支大型測試：

- `awesome-mail/tests/unit/routes/ai.test.ts`
- `awesome-mail/tests/unit/routes/auth.test.ts`
- `awesome-mail/tests/unit/routes/oauth.test.ts`

這批問題主要是：
- 以 `vi.fn().mockResolvedValue()`、`prepare.mockImplementation()` 疊出多層 D1 / KV / DO / fetch 行為
- 以 `vi.mock()` 或 `vi.spyOn()` 攔截 provider factory、Apple client secret 與 logger / cache 分支
- 測試檔過度依賴 mock framework，而不是直接驗證 route 與 hand-written fake 的互動

## 目標

1. 將上述 3 支 route 測試改成真實 JWT、hand-written Env / D1 / KV / DO / fetch fake 驅動。
2. 移除 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<`、`as Mock`。
3. 保持既有 route 行為覆蓋，包含成功路徑、驗證失敗、provider 錯誤與授權保護。
4. 驗證 batch 55 targeted tests 與 `awesome-mail` `npm run quality:check` 通過。

## 範圍

- `awesome-mail/tests/helpers/route-env-fakes.ts`
- `awesome-mail/tests/helpers/fetch-recorder.ts`
- `awesome-mail/tests/unit/routes/ai.test.ts`
- `awesome-mail/tests/unit/routes/auth.test.ts`
- `awesome-mail/tests/unit/routes/oauth.test.ts`

## 非目標

- backend `tests/unit/jobs/*`
- backend `tests/unit/middleware/*`
- backend `tests/unit/repositories/*`
- production route 邏輯的功能性改寫

## 驗收條件

1. batch 55 範圍檔案已清空上述 mock-heavy 關鍵字。
2. batch 55 targeted tests 全部通過。
3. `awesome-mail` `npm run quality:check` 通過。
