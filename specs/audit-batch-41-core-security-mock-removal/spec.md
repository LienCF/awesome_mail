# Spec: 批次 41 core security mock 清理

## 背景

`awesome_mail_flutter/test/unit/core/security` 仍有 3 支測試依賴 `mockito` 與 generated mocks，分別覆蓋生物辨識、憑證儲存與 PGP 服務。這些測試所依賴的邊界明確，適合改成手寫 fake / recorder，避免 generated mock 持續擴散。

## 目標

1. 將下列 3 支測試改成不依賴 `mockito`、`@GenerateMocks` 或 generated `.mocks.dart`
   - `awesome_mail_flutter/test/unit/core/security/biometric_service_test.dart`
   - `awesome_mail_flutter/test/unit/core/security/credential_manager_test.dart`
   - `awesome_mail_flutter/test/unit/core/security/pgp/pgp_service_test.dart`
2. 以手寫 fake / recorder 取代 `LocalAuthentication`、`EncryptionService`、`PGPKeyManager` 的 mock 行為
3. 刪除對應的 3 個 generated `.mocks.dart`
4. 通過 batch 41 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不修改 production security 流程
- 不擴大到 `test/unit/core/network` 或其他資料夾
- 不重寫已經沒有 mock framework 的 security analyzer / key manager 測試

## 驗收條件

- `awesome_mail_flutter/test/unit/core/security` 不再出現 `mockito`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`
- batch 41 相關測試全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
