# Feature Specification: 批次 7 跨堆疊品質閘修復

**Feature Branch**: `audit-batch-7-cross-stack-quality-gates`  
**Created**: 2026-03-20  
**Status**: Draft  
**Input**: User description: "全面分析專案內的所有程式(包含所有平台及程式語言的程式)，找出不符合規範的程式碼，規劃改善並執行"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - 維護者可重新取得綠燈品質閘 (Priority: P1)

我們團隊需要先把目前已經明確失敗的品質閘修回綠燈，才能繼續做下一批更深的審計與重構。

**Why this priority**: 這是所有後續改善的前置條件。如果格式檢查與靜態分析都無法通過，任何後續批次都缺乏穩定基線。

**Independent Test**: 在不修改其他模組功能的前提下，執行 backend `npm run quality:check` 與 Flutter `flutter analyze`，都能通過且不再報出這一批已知問題。

**Acceptance Scenarios**:

1. **Given** backend 目前有五個 TypeScript 檔案格式不符，**When** 維護者執行 backend 品質檢查，**Then** 格式檢查不再失敗。
2. **Given** Flutter 測試檔目前有六個 tearoff 類型 lint，**When** 維護者執行 `flutter analyze`，**Then** 不再出現這六個 lint。

---

### User Story 2 - 郵件 WebView 不再輸出直接 debug log (Priority: P2)

我們團隊需要讓郵件閱讀用的 WebView HTML 保持必要功能，但不要在執行階段直接輸出 `console.log` 除錯訊息。

**Why this priority**: 這屬於直接違反規範的執行中雜訊，且位於正式功能路徑，不應保留到下一批。

**Independent Test**: 透過測試驗證 WebView 產生的 HTML 仍包含必要行為腳本，但不再包含 `console.log`。

**Acceptance Scenarios**:

1. **Given** 郵件 HTML 內容，**When** 建立 WebView 文件字串，**Then** 文件中不包含 `console.log`。
2. **Given** 郵件 HTML 內容，**When** 建立 WebView 文件字串，**Then** 仍保留連結開新視窗與滾動相關腳本。

---

### User Story 3 - 審計結果可分批執行 (Priority: P3)

我們團隊需要把這次全專案審計的剩餘違規整理成可執行批次，避免後續修正失焦。

**Why this priority**: 專案規模大，違規類型橫跨多平台。沒有清楚分批，後續工作會混在一起，無法符合 Tidy First。

**Independent Test**: 更新後的審計報告可以清楚看出高、中、低優先級與下一批建議處理範圍。

**Acceptance Scenarios**:

1. **Given** 這次審計結果包含品質閘失敗、直接 debug log、輪詢/while loop、mock 濫用等問題，**When** 更新審計報告，**Then** 報告會標示已處理批次與待處理批次。
2. **Given** 後續還有大量違規未處理，**When** 維護者查看審計報告，**Then** 可以直接知道下一批建議從哪一組開始。

### Edge Cases

- 專案工作樹目前不是乾淨狀態，這一批不得覆寫使用者既有修改。
- iOS/macOS `Pods`、Flutter 產生檔與測試產生檔不納入維護程式碼審計。
- Flutter 全量測試耗時長，這一批若無法在單一回合跑完整套件，至少要先完成變更相關測試與靜態分析，並保留全量驗證結果。

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: 系統必須修復 backend `quality:check` 當前的 TypeScript 格式違規。
- **FR-002**: 系統必須修復 Flutter `analyze` 當前的六個 `unnecessary_lambdas` lint。
- **FR-003**: 系統必須讓 `EmailScrollableWebView` 產生的 HTML 文件不再輸出 `console.log`。
- **FR-004**: 系統必須以測試鎖定 `EmailScrollableWebView` HTML 文件的核心行為，避免移除 debug log 時連帶破壞既有腳本。
- **FR-005**: 系統必須更新審計報告，將剩餘違規分為可執行的後續批次。
- **FR-006**: 系統不得修改 vendored、產生或第三方依賴檔案來達成本批次需求。

### Key Entities *(include if feature involves data)*

- **Quality Gate Finding**: 一項目前直接造成品質閘失敗或違反專案規範的具體發現，包含檔案、規則類型、嚴重程度與驗證方式。
- **Audit Batch**: 一組可以一起處理的違規項目，具備明確範圍、優先級與完成條件。

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Backend `npm run quality:check` 在本批次修改後可通過目前這一輪已知格式檢查。
- **SC-002**: Flutter `flutter analyze` 在本批次修改後回報 0 個 issue。
- **SC-003**: `EmailScrollableWebView` 相關測試可驗證輸出的 HTML 不含 `console.log`，且保留必要腳本內容。
- **SC-004**: `tdd-audit-report.md` 可明確區分本批次已處理項目與至少兩個後續待處理批次。
