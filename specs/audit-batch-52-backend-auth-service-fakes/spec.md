# 規格：批次 52 backend AuthService fake 收斂

## 背景

batch 51 清完 fetch / OAuth 類 service 測試後，backend `tests/unit/services` 只剩 5 支 `AuthService` 與 OAuth account flow 測試仍依賴 `vi.mock()`、`vi.spyOn()`、`Mock` type cast 與 `.mockResolvedValue()`。

這批測試主要問題是：
- 以 mock repository 取代真實行為驗證
- 對 `generateTokens()`、`validateOAuthToken()`、`revokeTokens()` 等內部方法直接 spy
- 對 `jwt` / `crypto` 工具用 module mock 取代真實 token / 密碼行為

## 目標

1. 建立 backend 共用 AuthService test fake，支援 user repository、OAuth provider repository 與呼叫紀錄驗證。
2. 將 AuthService / OAuth flow 測試改成真實 JWT、真實密碼雜湊與 hand-written repository fake 驅動。
3. 清除 batch 52 範圍內的 `vi.fn`、`vi.mock`、`vi.spyOn`、`Mocked<`、`as Mock`、`.mockResolvedValue`、`.mockRejectedValue`、`.mockImplementation`、`.mock`。
4. 驗證 batch 52 targeted tests 與 `awesome-mail` `npm run quality:check` 通過。

## 範圍

- `awesome-mail/tests/helpers/auth-service-fakes.ts`
- `awesome-mail/tests/unit/services/auth-service.test.ts`
- `awesome-mail/tests/unit/services/auth-service-coverage.test.ts`
- `awesome-mail/tests/unit/services/auth-service-oauth.test.ts`
- `awesome-mail/tests/unit/services/oauth-edge-cases.test.ts`
- `awesome-mail/tests/unit/services/oauth-security.test.ts`

## 非目標

- backend routes / middleware / jobs / repositories 測試
- production `AuthService` 實作邏輯修改

## 驗收條件

1. batch 52 範圍檔案已清空上述 mock-heavy 關鍵字。
2. batch 52 targeted tests 全部通過。
3. `awesome-mail` `npm run quality:check` 通過。
