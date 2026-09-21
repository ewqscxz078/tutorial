# Security Rules

## Authentication
- 身分資訊不得信任前端傳入的 userId
- userId 必須來自已驗證 Principal / JWT / Session
- Controller 不得自行解析未驗證 JWT

## Authorization
- Authentication 不代表 Authorization
- 涉及資料存取時必須驗證資源 ownership
- 不得僅依 UI 隱藏功能作為權限控制

## Secrets
- 密碼、API Key、Private Key 不得 commit
- 正式環境 secrets 必須由 deployment environment 注入

## File Upload
- 不可信任原始 filename
- 防止 path traversal
- 驗證副檔名與實際內容
- ZIP 必須考慮 Zip Slip / Zip Bomb