# 規格：批次 56 backend jobs fake 收斂

## 背景

batch 55 已清掉 backend route 最後 3 支 mock-heavy 測試，目前 backend 剩餘違規中，`tests/unit/jobs` 是下一個最大且高度同質的群組：

- `awesome-mail/tests/unit/jobs/base-job.test.ts`
- `awesome-mail/tests/unit/jobs/cleanup-job.test.ts`
- `awesome-mail/tests/unit/jobs/cleanup-job-coverage.test.ts`
- `awesome-mail/tests/unit/jobs/health-check-job.test.ts`
- `awesome-mail/tests/unit/jobs/health-check-job-coverage.test.ts`
- `awesome-mail/tests/unit/jobs/job-manager.test.ts`
- `awesome-mail/tests/unit/jobs/usage-reset-job.test.ts`
- `awesome-mail/tests/unit/jobs/usage-reset-job-coverage.test.ts`

這批測試的主要問題是：
- 大量依賴 `vi.spyOn()`、`mockResolvedValue()`、`mockRejectedValue()`、`mockImplementation()` 攔截 `DB` / `KV` / `R2` 行為
- `tests/fixtures/job-test-data.ts` 仍使用 `mock*` 命名與鬆散的匿名物件，難以驗證真實互動
- 多支測試只是驗證 spy 是否被呼叫，沒有直接檢查 hand-written fake 的狀態與執行結果

## 目標

1. 將上述 8 支 jobs 測試改成 hand-written job fake 驅動。
2. 清掉 `vi.fn`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<`、`as Mock`。
3. 讓 job 測試改以 fake 的呼叫紀錄、儲存狀態與排程結果驗證真實行為。
4. 維持既有 jobs 覆蓋：成功路徑、錯誤處理、timeout / retry、schedule matching、alert 與 metrics 分支。
5. 驗證 batch 56 targeted tests 與 `awesome-mail` `npm run quality:check` 通過。

## 範圍

- `awesome-mail/tests/fixtures/job-test-data.ts`
- `awesome-mail/tests/unit/jobs/base-job.test.ts`
- `awesome-mail/tests/unit/jobs/cleanup-job.test.ts`
- `awesome-mail/tests/unit/jobs/cleanup-job-coverage.test.ts`
- `awesome-mail/tests/unit/jobs/health-check-job.test.ts`
- `awesome-mail/tests/unit/jobs/health-check-job-coverage.test.ts`
- `awesome-mail/tests/unit/jobs/job-manager.test.ts`
- `awesome-mail/tests/unit/jobs/usage-reset-job.test.ts`
- `awesome-mail/tests/unit/jobs/usage-reset-job-coverage.test.ts`

## 非目標

- backend `tests/integration/*`
- backend `tests/unit/middleware/*`
- backend `tests/unit/repositories/*`
- production jobs 邏輯的功能性擴充

## 驗收條件

1. batch 56 範圍檔案已清空上述 mock-heavy 關鍵字。
2. batch 56 targeted tests 全部通過。
3. `awesome-mail` `npm run quality:check` 通過。
