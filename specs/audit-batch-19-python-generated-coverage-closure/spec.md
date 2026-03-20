# Spec: 批次 19 Python 缺測與 generated 假陽性收尾

## 背景

Flutter 直接缺測收尾後，Python 清單只剩 2 項：

- `generate_todos.py`
- `awesome_mail_flutter/packages/foundation_models_framework/example/ios/Flutter/ephemeral/flutter_lldb_helper.py`

其中 `generate_todos.py` 是實際維護腳本，應補上直接測試；`flutter_lldb_helper.py` 則是 iOS example 目錄中的 generated ephemeral 檔案，檔頭已明確標示 `Generated file, do not edit.`，不應再被列為需補測對象。

## 問題陳述

若不把這兩項清掉，batch 10 會一直保留 Python 缺測尾巴，無法正式完成。這裡需要同時處理一個真缺測與一個 generated 假陽性。

## 使用者故事

### US1: Python 維護腳本與 generated 假陽性完成收尾

作為維護者，我們希望維護腳本有最小直接測試，而 generated ephemeral 檔案從缺測名單移除，讓 Python 缺測歸零。

#### 驗收條件

1. `generate_todos.py` 有直接測試，驗證批次切分與輸出格式。
2. `flutter_lldb_helper.py` 以 generated ephemeral 身分從缺測清單移除。
3. Python 剩餘缺測數降到 0。

## 非目標

- 不修改 `flutter_lldb_helper.py` 內容。
- 不處理其他非 Python 的 mock-heavy 或 happy-path 清單。

## 成功指標

- `python3 -m unittest` 的新增測試通過。
- `tdd-audit-report.md` 的 Python 缺測數降到 0。
- batch 10 的缺測收尾狀態完整更新。
