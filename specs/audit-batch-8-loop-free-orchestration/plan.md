> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Implementation Plan: 批次 8 迴圈與輪詢控制流清理

**Branch**: `audit-batch-8-loop-free-orchestration` | **Date**: 2026-03-20 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/audit-batch-8-loop-free-orchestration/spec.md`

## Summary

這一批聚焦在目前審計報告中最明確的 `while` / polling 類違規。我們先把真正長期執行的 polling 與重試流程改成事件驅動或有界遞迴，再把其餘串流/分頁/解析迴圈改成可界定的 helper，最後用既有測試與補充回歸測試鎖住行為。

## Technical Context

**Language/Version**: TypeScript 5.x、Dart 3.9  
**Primary Dependencies**: Hono、Vitest、Flutter、Drift、http、Firebase Messaging、bloc  
**Storage**: Drift SQLite、Cloudflare Request/ReadableStream  
**Testing**: `npm run quality:check`、`flutter analyze`、`flutter test`（變更相關 + 全量）  
**Target Platform**: Cloudflare Workers backend、Flutter macOS/iOS/跨平台客戶端  
**Project Type**: Monorepo（backend + mobile/desktop app）  
**Performance Goals**: 移除 AI queue idle polling；保留既有重試/下載/同步吞吐  
**Constraints**: 不覆寫既有使用者修改；不得降低重試上限或移除必要錯誤處理；維持現有公開 API  
**Scale/Scope**: 10 個候選違規檔案 + 相關單元/整合測試 + 1 份審計報告

## Constitution Check

- 行為變更先補測試，無法直接補測試的純結構性重構必須建立在既有綠燈測試上。
- AI 任務佇列改寫屬行為性變更，必須補上喚醒與延遲排程的回歸測試。
- 其餘 bounded retry / stream consumption 改寫若不改變外部行為，可在既有綠燈測試保護下進行。
- 所有重構完成後執行完整 backend/Flutter 驗證。

## Project Structure

### Documentation (this feature)

```text
specs/audit-batch-8-loop-free-orchestration/
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

**Structure Decision**: 沿用既有 backend / Flutter 模組，不新增新套件；只在必要時加入可測試 helper 或資料庫 helper。

## Implementation Strategy

### Phase 0: 審計收斂

- 重新確認 10 個 `while` 候選檔案與對應測試面。
- 區分「真正 polling」與「可界定的串流/分頁/重試控制流」。

### Phase 1: 先補紅燈測試

- 為 `AiTaskQueueService` 補上 idle 喚醒與延遲任務處理測試。
- 為通知 APNS token 重試與 Gmail rate limit helper 補上可測試的純函式或 helper 測試。

### Phase 2: 行為改寫

- 將 `AiTaskQueueService` 改為由新任務與 `scheduled_at` Timer 喚醒，不再固定輪詢。
- 將 request guard、Gmail retry、下載器、通知 APNS、Foundation AI readiness、mailbox 同步與 POP3 multiline parsing 改成有界遞迴或 helper 消費流程。

### Phase 3: 驗證與報告

- 執行 backend 品質檢查與 Flutter analyze。
- 執行變更相關測試，再跑 Flutter 全量測試。
- 更新 `tdd-audit-report.md`，反映本批次已處理項目與剩餘清單。

## Risks And Mitigations

- AI queue 改寫最容易出現漏喚醒：透過資料庫 helper + Timer 排程測試鎖住。
- Flutter 全量測試耗時長：先跑變更相關測試，再跑全量。
- POP3 與 request stream 都是低階 I/O 流程：只改控制流形狀，不改終止條件與資料組裝方式。
