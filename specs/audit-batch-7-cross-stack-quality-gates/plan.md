> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Implementation Plan: 批次 7 跨堆疊品質閘修復

**Branch**: `audit-batch-7-cross-stack-quality-gates` | **Date**: 2026-03-20 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/audit-batch-7-cross-stack-quality-gates/spec.md`

## Summary

這一批先清掉目前最直接、最可驗證的高優先違規，建立可繼續審計的乾淨基線。範圍包含 backend 五個 TypeScript 檔案格式修正、Flutter 六個 tearoff lint 修正、`EmailScrollableWebView` 的直接 `console.log` 移除與對應測試補強，以及審計報告批次更新。

## Technical Context

**Language/Version**: TypeScript 5.x、Dart 3.9、少量內嵌 JavaScript  
**Primary Dependencies**: ESLint、Prettier、Vitest、Flutter、very_good_analysis、flutter_inappwebview  
**Storage**: N/A  
**Testing**: `npm run quality:check`、`flutter analyze`、`flutter test`（至少執行變更相關測試）  
**Target Platform**: Cloudflare Workers backend、Flutter 跨平台客戶端、macOS WebView  
**Project Type**: Monorepo（backend + mobile/desktop app）  
**Performance Goals**: 這一批不改變功能效能，只恢復品質閘綠燈  
**Constraints**: 不可覆寫既有使用者修改、不碰 `Pods`/產生檔、維持 WebView 核心腳本行為  
**Scale/Scope**: 9 個主要維護檔案 + 1 份審計報告

## Constitution Check

- 遵循 Detroit School TDD：行為變更先補測試，再做實作。
- 遵循 Tidy First：格式與 tearoff 屬結構性修正；WebView HTML log 移除屬行為性修正，需和測試一起完成。
- 不修改第三方依賴、產生檔或 vendored 檔案。
- 每個修正完成後執行對應驗證，最後再做整體驗證。

## Project Structure

### Documentation (this feature)

```text
specs/audit-batch-7-cross-stack-quality-gates/
├── spec.md
├── plan.md
└── tasks.md
```

### Source Code (repository root)

```text
awesome-mail/
├── src/
└── tests/

awesome_mail_flutter/
├── lib/
├── test/
└── integration_test/
```

**Structure Decision**: 這一批只觸及 monorepo 內既有 backend 與 Flutter 客戶端檔案，不新增新模組。

## Implementation Strategy

### Phase 0: 審計收斂

- 將目前可直接驗證的高優先違規收斂成單一批次。
- 確認後續待處理議題保留在審計報告，不混入本批次程式修改。

### Phase 1: 結構性修正

- 以 Prettier 修正 backend 五個 TypeScript 檔案格式。
- 以 tearoff 取代不必要 lambda，讓 Flutter `analyze` 綠燈。

### Phase 2: 行為性修正

- 先補 `EmailScrollableWebView` HTML 文件測試，鎖定不含 `console.log` 且保留必要腳本。
- 再抽出可測試的 HTML builder，移除直接 debug log。

### Phase 3: 驗證與報告

- 執行 backend 品質檢查、Flutter analyze、變更相關 Flutter 測試。
- 更新 `tdd-audit-report.md`，記錄本批次完成狀態與下一批建議。

## Risks And Mitigations

- `flutter test` 全量執行時間長：本批次先確保變更相關測試與靜態分析通過，再補回全量驗證結果。
- WebView HTML 由私有方法組裝：透過抽出可測試 helper，降低日後回歸風險。
- 工作樹已有其他變更：只修改本批次必要檔案，不碰無關檔案。
