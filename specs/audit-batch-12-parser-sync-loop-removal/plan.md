> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 12 parser / sync / pagination 控制流清理

## 技術策略

1. 先補 parser、retry、pagination 的 red 測試，特別是 partial failure、page token 推進與巢狀結構解析。
2. 以遞迴 helper、索引前進函式與 page processing helper 取代 `while` / `do-while`。
3. 每完成一類控制流就跑對應測試，整批完成後再執行 backend / Flutter 驗證與最終掃描。

## 分組實作

### A. Parser 狀態機

- `imap_response_parser.dart`

### B. Retry 與 checkpoint

- `email_synchronizer.dart`
- `base-job.ts`

### C. Gmail 分頁同步

- `gmail_repository.dart`

## 驗證策略

- Flutter:
  - `imap_response_parser`、`email_synchronizer`、`gmail_repository` 相關測試
  - `flutter analyze`
- Backend:
  - `base-job.test.ts`
  - `npm run quality:check`
- 稽核:
  - 重新掃描全專案 `while` / `do-while`
  - 更新 `tdd-audit-report.md`
