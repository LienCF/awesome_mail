> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 計劃：backend 殘留 mock 路徑命名清理

## 技術背景

- backend 功能與測試已通過，但仍有少量檔名與 helper API 沿用 `mock` 路徑命名
- 這些殘留集中在 AI provider、OAuth 測試服務與 D1 測試 helper

## 實作策略

### Phase 1：收斂檔名與匯入

- 將 `ai-provider-mock.ts`、`ai-provider-mock.test.ts`、`ai-mock-api.test.ts` 改為 `simulated` 命名
- 將 `mock-d1.ts` 改為 `test-d1.ts`
- 將 `oauth-mock-services.ts` 改為 `oauth-simulated-services.ts`

### Phase 2：同步更新 helper API 與區域命名

- 調整 D1 helper 的 `testD1` 回傳值與建構函式名稱
- 更新 OAuth 模擬服務內部 API 名稱，讓呼叫端不再依賴 `setMockResponse` 之類的舊語意
- 清理這批檔案中的英文註解

### Phase 3：回歸驗證

- `rg --files awesome-mail/src awesome-mail/tests | rg "mock|Mock"`
- `npm run quality:check`
