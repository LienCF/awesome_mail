> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 19 Python 缺測與 generated 假陽性收尾

**Input**: Design documents from `specs/audit-batch-19-python-generated-coverage-closure/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認 `generate_todos.py` 為真缺測、`flutter_lldb_helper.py` 為 generated ephemeral 假陽性
- [x] T002 以紅燈方式執行尚不存在的 Python 測試檔路徑

## Phase 2: User Story 1 - Python 維護腳本與 generated 假陽性完成收尾 (Priority: P1)

**Goal**: 讓 Python 缺測歸零**

**Independent Test**: `python3 -m unittest discover -s python_tests -p 'test_*.py'` 通過，且 `tdd-audit-report.md` 不再列出 2 個 Python 項目

- [x] T003 [US1] 新增 `python_tests/test_generate_todos.py`
- [x] T004 [US1] 執行 Python 測試並確認通過
- [x] T005 [US1] 更新 `tdd-audit-report.md`，移除 generated 假陽性並將 Python 缺測數下修到 0

## Phase 3: Polish & Cross-Cutting Concerns

- [x] T006 更新 batch 19 `tasks.md` 狀態
