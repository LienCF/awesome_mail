# Feature Specification: 批次 8 迴圈與輪詢控制流清理

**Feature Branch**: `audit-batch-8-loop-free-orchestration`  
**Created**: 2026-03-20  
**Status**: Draft  
**Input**: User description: "全面分析專案內的所有程式(包含所有平台及程式語言的程式)，找出不符合規範的程式碼，規劃改善並執行"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - 維護者可移除有界重試與分頁中的 `while` 控制流 (Priority: P1)

我們團隊需要把 request guard、通知初始化、Gmail 重試、資料夾分頁與背景下載中的 `while` 迴圈改寫成可推論的有界控制流程，避免之後維護時再引入無窮迴圈風險。

**Why this priority**: 這一批多數位於核心同步與網路流程，發生錯誤時很容易放大成資源耗盡或重試失控。

**Independent Test**: 執行對應單元測試與既有回歸測試，確認 request guard、Gmail rate limit retry、下載排程與資料夾安全掃描行為不變。

**Acceptance Scenarios**:

1. **Given** 沒有 `content-length` 的 JSON request body，**When** request guard 讀取串流內容，**Then** 仍能在超過上限時拒絕，在未超過上限時保留原始 JSON 給下游解析。
2. **Given** Gmail API 回傳 429，**When** 重試流程執行，**Then** 仍會遵守最大重試次數與退避規則，但不再使用無界 `while (true)`。
3. **Given** 批次資料夾安全掃描與完整內容下載，**When** 逐頁或逐項處理任務，**Then** 仍能完整處理全部項目，但控制流程改為可界定的遞迴或排程。

---

### User Story 2 - 維護者可移除背景工作中的 polling 迴圈 (Priority: P1)

我們團隊需要讓 AI 任務佇列在 idle 時不再每 500ms 輪詢資料庫，而是改成由新任務或下一個排程時間喚醒。

**Why this priority**: 這是目前最直接違反「避免 polling」規範的程式，長時間執行會持續消耗 CPU 與資料庫查詢。

**Independent Test**: AI 任務佇列在沒有待執行工作時不會靠固定輪詢維持運作，新增或延後的任務仍會準時被處理。

**Acceptance Scenarios**:

1. **Given** 佇列中沒有到期任務，**When** 背景處理器啟動，**Then** 它會等待下一個排程點或新任務喚醒，而不是固定輪詢。
2. **Given** 新任務在佇列 idle 時加入，**When** 任務寫入完成，**Then** 處理器會立即被喚醒執行。
3. **Given** 任務失敗後被 backoff 重排，**When** 下一次排程時間到達，**Then** 處理器會在正確時間重新執行該任務。

---

### User Story 3 - 維護者可將剩餘 `while` 類違規縮減到可接受清單 (Priority: P2)

我們團隊需要把目前審計報告中的 `while` 類違規清單更新為剩餘真正需要後續處理的項目，避免同一批問題反覆出現。

**Why this priority**: 若不更新報告，我們無法判斷本批次到底消化了多少違規，也無法繼續往下一批前進。

**Independent Test**: 更新後的審計報告會列出本批次已處理檔案與仍待處理的少數高風險項目。

**Acceptance Scenarios**:

1. **Given** 本批次完成後，**When** 維護者重新查看審計報告，**Then** 會看到已完成的 `while`/polling 修正清單。
2. **Given** 仍有不適合在本批次一併處理的剩餘項目，**When** 維護者查看審計報告，**Then** 能清楚知道剩餘項目與原因。

### Edge Cases

- POP3 multiline response 與 request body 串流讀取都屬於「直到結束符號/串流完成」的流程，改寫後不得破壞原本的結束條件。
- AI 任務佇列若在處理中被 `stop()`，不得遺留無法再喚醒的狀態。
- Gmail `Retry-After` 可能為秒數或日期字串，改寫後必須保留原本解析邏輯。
- 工作樹仍包含使用者既有未提交變更，本批次不得覆寫無關檔案。

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: 系統必須移除 `awesome-mail/src/middleware/request-guard.ts` 中的無界 `while (true)`。
- **FR-002**: 系統必須移除 `awesome_mail_flutter/lib/core/notifications/notification_service.dart` 中 APNS token 等待的 `while` 重試。
- **FR-003**: 系統必須移除 `awesome_mail_flutter/lib/data/services/gmail_remote_service.dart` 中 rate limit retry 的 `while (true)`。
- **FR-004**: 系統必須移除 `awesome_mail_flutter/lib/data/services/full_content_download_service.dart`、`awesome_mail_flutter/lib/data/services/ai_task_queue_service.dart` 中以 `while` 驅動的批次處理流程。
- **FR-005**: 系統必須將 `AiTaskQueueService` 的 idle polling 改為事件驅動或依排程時間喚醒。
- **FR-006**: 系統必須移除 `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_core.dart`、`awesome_mail_flutter/lib/presentation/blocs/mailbox/mailbox_bloc.dart`、`awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_sync_handlers.dart` 中的 `while` 控制流，改成可界定的重試或遞迴流程。
- **FR-007**: 系統必須移除 `awesome_mail_flutter/lib/data/protocols/pop3/pop3_handler.dart` 中的 `while (true)`，同時保留 multiline response 的完整解析行為。
- **FR-008**: 系統必須以測試或既有回歸驗證鎖定上述流程的既有行為。
- **FR-009**: 系統必須更新 `tdd-audit-report.md`，記錄本批次已消化的 `while`/polling 類違規。
- **FR-010**: 系統不得透過單純關閉檢查、註解掉流程或降低重試能力來滿足本批次要求。

### Key Entities *(include if feature involves data)*

- **Loop-Free Flow**: 用遞迴、有限次重試、Timer 喚醒或串流消費取代 `while` 的控制流程實作。
- **Queue Wake Signal**: AI 任務佇列在新任務加入或下一個 `scheduled_at` 到達時，用來喚醒處理器的事件或計時器。
- **Audit Snapshot**: 本輪審計對 `while`/polling 類違規的最新完成狀態與剩餘清單。

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 這一批列出的 10 個 `while`/polling 候選檔案，全部完成改寫或明確降為非違規實作。
- **SC-002**: Backend 與 Flutter 相關測試在本批次改寫後全部通過。
- **SC-003**: `AiTaskQueueService` idle 時不再以固定 500ms 查詢資料庫。
- **SC-004**: `tdd-audit-report.md` 能列出本批次已處理檔案與剩餘待處理項目數。
