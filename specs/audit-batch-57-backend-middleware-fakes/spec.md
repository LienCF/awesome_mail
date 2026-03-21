> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Spec: 批次 57 backend middleware fake 收斂

## 背景

backend `tests/unit/middleware` 仍有 8 支測試依賴 `vi.mock`、`vi.fn`、`vi.spyOn` 與 `mockResolvedValue` 類互動驗證，違反 Detroit School TDD 對真實行為與 hand-written fake 的要求。這批要把 auth、error-handler 與 rate-limit 測試改成真 JWT、hand-written DB / KV / logger recorder / context fake 驅動，同時維持 `awesome-mail` 全量品質閘為綠燈。

## 目標

1. 清掉 `tests/unit/middleware` 8 支測試內的 mock framework 關鍵字與 generated interaction style。
2. 讓 auth middleware 測試改成真 JWT、真 Hono app、hand-written D1 / KV fake 驅動。
3. 讓 error-handler 測試改成真 Hono app、手寫 logger recorder / context fake 驅動。
4. 讓 rate-limit 補充測試改成手寫 KV fake 與真 request/response 驅動。
5. targeted tests、搜尋驗證與 `npm run quality:check` 全部通過。

## 非目標

1. 不修改 middleware 對外 API。
2. 不清理 `tests/unit/middleware` 以外的 backend mock-heavy 檔案。
3. 不順便調整 coverage 無關的 production 邏輯，除非測試揭露真實缺陷。

## 驗收標準

1. `rg` 檢查 batch 57 範圍內不再出現 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`。
2. `npx vitest run` 執行 batch 57 的 8 支 middleware 測試全部通過。
3. `awesome-mail` 的 `npm run quality:check` 通過，且沒有新增 lint / type-check / coverage 問題。
