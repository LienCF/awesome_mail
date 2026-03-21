# Spec: 批次 50 backend service D1/KV fake 基礎收斂

## 背景

Flutter 端 mock-heavy 測試已清空，backend 全域重掃後仍有 80 個檔案含有 `vi.fn()`、`vi.spyOn()`、`mockResolvedValue*`、`mockRejectedValue*` 等 Detroit School 違規。第一個 backend 收斂點集中在 `tests/unit/services` 中依賴 `D1Database`、`KVNamespace` 與少量 service 私有 helper 的測試，這些檔案共享同一類外部邊界，適合先抽成 hand-written fake / recorder。

## 目標

1. 將下列 backend service 測試改成不依賴 `vi.fn()`、`vi.spyOn()`、`mockResolvedValue*`、`mockRejectedValue*` 或其他 mock framework API
   - `awesome-mail/tests/helpers/mock-d1.ts`
   - `awesome-mail/tests/unit/services/ai-cache-coverage.test.ts`
   - `awesome-mail/tests/unit/services/ai-cache.test.ts`
   - `awesome-mail/tests/unit/services/ai-usage-tracker-coverage.test.ts`
   - `awesome-mail/tests/unit/services/ai-usage-tracker.test.ts`
   - `awesome-mail/tests/unit/services/subscription-service.test.ts`
   - `awesome-mail/tests/unit/services/sync-service-coverage.test.ts`
   - `awesome-mail/tests/unit/services/sync-service.test.ts`
   - `awesome-mail/tests/unit/services/token-vault.test.ts`
   - `awesome-mail/tests/unit/services/usage-tracker.test.ts`
   - `awesome-mail/tests/unit/services/user-service.test.ts`
2. 在 `tests/helpers/mock-d1.ts` 內提供可重用的 hand-written fake / recorder，覆蓋 D1 statement queue、SQL 路由、KV 讀寫紀錄與錯誤注入
3. 對需要觀察 service 私有流程的測試，改用 subclass / recorder / 可檢查的 fake repository 或 fake method override，而不是 `spyOn()`
4. 保留既有測試的驗證力，持續覆蓋 happy path、錯誤處理、資料寫入內容與版本衝突等真實行為

## 非目標

- 不處理 fetch 為主的 OAuth / AI provider service 測試
- 不擴大到 `tests/unit/routes/*`、`tests/unit/jobs/*`、`tests/integration/*`
- 不修改 production 行為，除非改寫測試過程暴露真實缺陷且必須先補回歸測試

## 驗收條件

- 上述 10 支 service 測試與 `tests/helpers/mock-d1.ts` 不再出現 `vi.fn()`、`vi.spyOn()`、`mockResolvedValue*`、`mockRejectedValue*`
- batch 50 targeted tests 全部通過
- `awesome-mail` 的 `npm run quality:check` 通過
- `tdd-audit-report.md` 更新 batch 50 結果與 backend 剩餘數量
