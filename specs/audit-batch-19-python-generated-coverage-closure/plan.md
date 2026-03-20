> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 19 Python 缺測與 generated 假陽性收尾

## 技術策略

1. 先以紅燈方式執行尚不存在的 Python 測試目錄或檔案。
2. 新增 `python_tests/test_generate_todos.py`，直接匯入 `generate_todos.py`，驗證：
   - 回傳資料型態為 list of dict
   - 每筆 status 為 `pending`
   - description 依 5 檔一批的規則切分
3. 以檔頭與路徑身分證明 `flutter_lldb_helper.py` 為 example iOS ephemeral generated file，從缺測清單移除。
4. 更新 `tdd-audit-report.md` 與 batch 19 `tasks.md`，讓 Python 缺測數歸零。

## 驗證策略

- `python3 -m unittest discover -s python_tests -p 'test_*.py'`
- 更新 `tdd-audit-report.md` 與 batch 19 `tasks.md`
