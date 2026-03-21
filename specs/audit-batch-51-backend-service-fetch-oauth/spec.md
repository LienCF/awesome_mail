# 規格：批次 51 backend service fetch / OAuth fake 收斂

## 背景

backend `tests/unit/services` 尚有一批以 `vi.fn()`、`vi.spyOn()`、`mockResolvedValue()` 與 `.mock.calls` 驅動的 fetch / OAuth 類測試。這些測試過度依賴 mock framework，不符合 Detroit School 對「以真實行為與手寫替身驗證」的要求。

batch 51 聚焦清理 fetch / OAuth 類 service 測試，透過 hand-written fetch recorder、真實 crypto 行為與簡單 fake 取代 mock queue API。

## 目標

1. 建立 backend 共用 fetch recorder，支援 Response / error queue 與呼叫紀錄驗證。
2. 將 fetch / OAuth 類 service 測試改成 hand-written fake 或真實行為驗證。
3. 清除 batch 51 範圍內的 `vi.fn`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<`、`as Mock` 關鍵字。
4. 驗證 batch 51 targeted tests 與 `awesome-mail` `npm run quality:check` 通過。

## 範圍

- `awesome-mail/tests/helpers/fetch-recorder.ts`
- `awesome-mail/tests/unit/services/ai-provider-anthropic.test.ts`
- `awesome-mail/tests/unit/services/ai-provider-openai.test.ts`
- `awesome-mail/tests/unit/services/ai-provider-openrouter.test.ts`
- `awesome-mail/tests/unit/services/ai-service.test.ts`
- `awesome-mail/tests/unit/services/apple-client-secret-service.test.ts`
- `awesome-mail/tests/unit/services/apple-oauth-service.test.ts`
- `awesome-mail/tests/unit/services/google-oauth-service.test.ts`
- `awesome-mail/tests/unit/services/oauth-exchange-apple.test.ts`
- `awesome-mail/tests/unit/services/oauth-exchange-coverage.test.ts`
- `awesome-mail/tests/unit/services/oauth-exchange-google.test.ts`
- `awesome-mail/tests/unit/services/oauth-exchange-outlook.test.ts`
- `awesome-mail/tests/unit/services/oauth-refresh-service.test.ts`
- `awesome-mail/tests/unit/services/oauth-validation-service.test.ts`

## 非目標

- `AuthService` 與 OAuth repository 類 service 測試
- backend routes / middleware / jobs / repositories 測試
- production service 實作行為變更

## 驗收條件

1. batch 51 範圍檔案已清空上述 mock-heavy 關鍵字。
2. batch 51 targeted tests 全部通過。
3. `awesome-mail` `npm run quality:check` 通過。
