# AI Source Code Security Review Specification

Specification Version: 2.1
Updated: 2026-09-21
Default Report: `reports/ai/security/security-review-report-YYYYMMDD.html`

> 本文件是 Repository 內可版本控管的 AI Source Code Security Review 執行規格。
>
> 當 AI / Coding Agent 被要求「執行本文件」時，應直接依照本文件完成安全檢視，並產生指定的 Security Review Report。
>
> 使用者不需要另外提供 Security Review Prompt、檢查清單、掃描流程、報告格式或報告語言。

---

# 1. Document Purpose

本文件同時定義：

```text
HOW TO SCAN
怎麼掃

WHAT TO SCAN
掃什麼

HOW TO REDUCE FALSE POSITIVES
怎麼降低誤報

HOW TO REPORT
怎麼產出報告
```

本文件應與 Source Code 一起：

```text
Commit
Review
Version Control
Change History
```

使不同時間、不同開發者、不同 AI / Coding Agent 執行 Security Review 時，具有一致的最低檢查標準。

---

# 2. Execution Contract

當 AI / Coding Agent 收到以下或相同語意的指令：

```text
請執行 docs/security-review.md
```

即代表：

> 對目前 Repository 執行本文件所定義的完整 Source Code Security Review，並依本文件規格產生 Security Review Report。

除非缺少完成分析所必要的資訊，否則：

* 不要求使用者重新描述 Security Review 規則。
* 不要求使用者重新列出檢查項目。
* 不要求使用者逐一指定 Controller / Handler。
* 不要求使用者提供額外 Prompt。
* 不要求使用者另外指定報告格式。
* 不要求使用者另外指定報告語言。
* 不因缺少專案特定 Security 文件而停止。
* 應自行從 Repository 建立必要的 Security Context。

---

# 3. Default Execution Mode

預設執行模式：`READ → ANALYZE → TRACE → COMPARE → REPORT → RECOMMEND`。

只允許在 Repository 相對路徑 `reports/ai/security/` 建立或更新本次執行日期的 `security-review-report-YYYYMMDD.html`；目錄不存在時應先建立。若同日報告仍引用失效的 Finding，須依本次完整檢視結果更新。其他日期的歷史報告不得覆寫或刪除，Repository 根目錄的舊版 `security-review-report.html` 不再視為預設更新目標。除非使用者另外明確要求修正，預設禁止修改 Source Code、Security Configuration、Authorization Rule、Endpoint、Database Query、API Contract 或其他 Repository 檔案。Security Review 與 Security Fix 分為兩個階段。

Attack Simulation 是 Source Code Reasoning；不得對正式系統送出惡意請求、取得真實敏感資料或修改真實資料。

---

# 4. Report Language and Output File

正式報告統一輸出至 Repository 相對路徑 `reports/ai/security/`，檔名格式為 `security-review-report-YYYYMMDD.html`。`YYYYMMDD` 以實際執行 Security Review 當日的執行環境當地日期為準，並須與報告內的 `Review Date` 一致；例如於 2026-09-21 執行時，輸出為 `reports/ai/security/security-review-report-20260921.html`。除非使用者明確要求，不另外產生 Markdown 報告。報告應為單一可離線開啟的 Standalone HTML；具體結構見第 44 節。

若 Repository 已存在同一執行日期的報告，完成本次 Review 時須依實際結果更新，不得保留已失效 Finding。其他日期的歷史報告不得覆寫或刪除；Repository 根目錄既有的 `security-review-report.html` 不視為本次 Review 的預設更新目標。

## 4.1 Report Language

主要內容固定使用繁體中文（zh-TW），除非使用者當次明確指定其他語言。不得因 Repository、Source Code、Framework 或識別字使用英文而自行改成英文報告。

## 4.2 Technical Terminology

Authentication、Authorization、IDOR／BOLA、BFLA、Mass Assignment、Excessive Data Exposure、Tenant Isolation、Workflow Bypass、Race Condition、Replay、Fail-open／Fail-closed、Endpoint、Controller、Service、Repository、Entity、DTO、JWT、RBAC、ABAC 等標準技術術語可以維持英文，建議以繁體中文解釋其意義。

## 4.3 Source Identifiers

File Path、Package、Class、Method、Variable、Field、Entity、DTO、Database Table／Column、HTTP Method、Endpoint Path、Configuration Key、Role、Authority、JWT Claim、Header 維持 Source Code 原始名稱。

## 4.4 Code and Evidence

Source Code、Log、Configuration 與 Evidence 保持原始內容，不為翻譯而改動；輸出 HTML 時須跳脫 HTML 特殊字元，遮罩真實密碼、Token、金鑰及個資，以便安全閱讀。

---

# 5. Repository Scope

預設 Review Scope：

```text
Current Repository
```

AI 應自行辨識：

```text
Source Code
Configuration
Security Configuration
Controller / Handler
Service
Repository / DAO
Entity / Domain
Request DTO
Response DTO
Mapper
Filter
Middleware
Interceptor
AOP
Authorization Utility
Exception Handler
Logging Configuration
```

不應只掃描單一 Controller 或目錄。

---

# 6. Repository Context Discovery

正式產生 Finding 前，先建立 Project Security Context。

優先尋找並閱讀 Repository 中存在的相關文件，例如：

```text
AGENTS.md
README.md
architecture.md
security.md
development.md
api-conventions.md
deployment.md
security-review-project.md
```

以上文件：

> 有則閱讀，無則繼續。

不得因任何一份不存在而停止 Security Review。

---

# 7. Source Code Is Final Evidence

Repository 文件可以協助理解設計，但不得直接視為實作證據。

例如文件宣告：

```text
所有 API 都有 RBAC。
```

不能因此直接判定所有 Endpoint 安全。

AI 必須繼續確認 Source Code 實際 Enforcement。

證據優先順序：

```text
Actual Source Code / Configuration
          ↓
Security Implementation
          ↓
Repository Documentation
          ↓
Naming / Assumption
```

若文件與實作不一致，必須列入 Review。

---

# 8. Project Security Context

Review 開始時自行建立：

```text
Project:
<detected>

Application Type:
<detected>

Technology / Framework:
<detected>

Authentication:
<detected / unknown>

Authorization:
<detected / unknown>

Session / Token Mechanism:
<detected / unknown>

Tenant Model:
<detected / none / unknown>

Security Entry Points:
<detected>

Sensitive Domains:
<detected / unknown>

Critical Workflows:
<detected / unknown>
```

無法確認：

```text
UNKNOWN
```

不得自行假設。

---

# 9. Threat Model

所有 Review 必須假設攻擊者可以自行構造 HTTP Request，例如：

```text
curl
Postman
Burp Suite
Browser DevTools
Custom HTTP Client
Script
```

因此：

```text
Path Variable
Query Parameter
Request Body
Form Parameter
HTTP Header
Cookie
Hidden Field
Frontend Generated Value
```

預設均屬：

```text
UNTRUSTED INPUT
```

除非存在可驗證的 Trusted Boundary。

---

# 10. Frontend Is Not Security Boundary

以下不得單獨視為有效 Authorization：

```text
Hidden Button
Disabled Button
Frontend Role Check
Route Guard
Hidden Input
JavaScript Validation
UI 沒有入口
URL 沒有顯示
```

Server 必須自行 Enforcement。

---

# 11. Authentication != Authorization

每個重要 Endpoint 應區分：

```text
Authentication
    ↓
Who are you?

Authorization
    ↓
Can you perform this operation?

Resource Ownership
    ↓
Can you operate THIS resource?

Tenant Boundary
    ↓
Does this resource belong to your security boundary?

Workflow Authorization
    ↓
Can you perform this operation NOW?
```

不得因為 Endpoint 要求登入，就認定不存在越權。

---

# 12. Review Execution Pipeline

完整 Review 預設依以下 Phase 執行：

```text
Phase 0
Repository Context Discovery

        ↓

Phase 1
Application / Security Architecture Discovery

        ↓

Phase 2
HTTP Endpoint Inventory

        ↓

Phase 3
Authentication Mapping

        ↓

Phase 4
Authorization Mapping

        ↓

Phase 5
Controller → Service → Repository Trace

        ↓

Phase 6
Resource Ownership Analysis

        ↓

Phase 7
Tenant Boundary Analysis

        ↓

Phase 8
Request Trust / Mass Assignment Analysis

        ↓

Phase 9
Response / Data Exposure Analysis

        ↓

Phase 10
Workflow / Business Logic Analysis

        ↓

Phase 11
Replay / Concurrency Analysis

        ↓

Phase 12
Logging / Error / File / Export Analysis

        ↓

Phase 13
Cross-endpoint Consistency Analysis

        ↓

Phase 14
Attack Simulation

        ↓

Phase 15
False Positive Verification

        ↓

Phase 16
Finding Classification

        ↓

Phase 17
Report Generation
```

不得直接從 Pattern Search 跳到 Finding。

---

# 13. Endpoint Inventory

盤點所有可能對外暴露的 Endpoint。

依 Framework 尋找：

```text
Controller
Handler
Route
Endpoint
Resolver
Servlet
RPC Endpoint
```

至少記錄：

```text
HTTP Method
Path
Controller / Handler
Authentication Requirement
Authorization Requirement
Input Model
Output Model
Service
Repository
```

同時關注：

```text
admin
internal
legacy
old
deprecated
test
debug
export
download
batch
callback
webhook
```

---

# 14. Trace Model

對每個重要 Endpoint，盡可能追蹤：

```text
HTTP Request
      ↓
Security Layer
      ↓
Controller / Handler
      ↓
Request DTO
      ↓
Service / Business Logic
      ↓
Repository / DAO
      ↓
Entity / Domain
      ↓
Mapper
      ↓
Response DTO
      ↓
HTTP Response
```

如果 Authorization 位於：

```text
Gateway
Filter
Middleware
Interceptor
AOP
Annotation
Service
Repository
Policy Engine
```

必須納入分析。

---

# 15. SEC-AUTH-001 — Trusted Authentication Identity

檢查：

> Server 如何知道目前使用者是誰？

可信任來源可能包括：

```text
Security Context
Principal
Authentication Context
Verified JWT Claim
Server Session
Trusted Identity Provider
Trusted Gateway Identity
```

高風險候選：

```text
request.userId
request.accountId
request.username
request.memberId
```

如果 Client 提供的 Identity 被當成目前登入者，必須追蹤完整資料流。

---

# 16. SEC-AUTHZ-001 — IDOR / BOLA

對所有 Client 可指定 Resource Identifier 的 API：

```text
/resource/{id}
/user/{id}
/order/{id}
/file/{id}
/document/{id}
/download/{id}
```

確認：

```text
Authentication
      ↓
Resource Lookup
      ↓
Ownership / Authorization
      ↓
Operation
```

不得只有：

```text
findById(id)
```

就直接操作。

Attack Simulation：

```text
User A:

GET /resource/1001

↓

修改

GET /resource/1002

↓

Resource 1002 belongs to User B
```

檢查 User A 是否仍能：

```text
READ
UPDATE
DELETE
DOWNLOAD
EXECUTE
```

---

# 17. SEC-AUTHZ-002 — BFLA

檢查 Function Level Authorization。

特別關注：

```text
admin
manage
approve
reject
delete
enable
disable
export
download
audit
configuration
batch
```

核心問題：

> 一般使用者直接呼叫敏感 Endpoint 時，Server 是否拒絕？

---

# 18. SEC-AUTHZ-003 — Authorization Consistency

比較相似 Endpoint：

```text
GET vs PUT vs DELETE
single vs batch
view vs download
view vs export
user vs admin
current vs legacy
v1 vs v2
```

尋找：

```text
Endpoint A → Authorization
Endpoint B → Missing / Different Authorization
```

不得只逐支 Endpoint 獨立分析。

---

# 19. SEC-AUTHZ-004 — Fail-open

分析 Security Control 發生：

```text
Exception
Timeout
Unavailable
Invalid Configuration
Unknown Role
Token Parse Failure
Permission Service Failure
```

時：

```text
FAIL
 ↓
DENY
```

還是：

```text
FAIL
 ↓
CONTINUE
```

Security Verification 無法完成時原則上應 Fail Closed。

---

# 20. SEC-INPUT-001 — Mass Assignment

尋找：

```text
Request
   ↓
Automatic Mapping
   ↓
Entity
   ↓
Save
```

例如：

```text
@RequestBody Entity
Request → Entity Mapper
Bean Copy
Generic Mapper
Reflection Mapping
```

特別檢查：

```text
role
authority
permission
approved
enabled
status
ownerId
userId
tenantId
organizationId
createdBy
updatedBy
price
amount
balance
isAdmin
```

核心問題：

> Client 到底允許修改哪些欄位？

應優先確認是否採用 Allowlist Mapping。

---

# 21. SEC-INPUT-002 — Security-sensitive Client Fields

若 Request 包含：

```text
userId
ownerId
tenantId
organizationId
role
permission
status
approved
enabled
price
amount
createdBy
```

必須詢問：

> 為什麼這個值可以由 Client 決定？

如果無法從程式或業務規則證明合理：

```text
NEEDS_REVIEW
```

---

# 22. SEC-OUTPUT-001 — Excessive Data Exposure

尋找：

```text
Entity → HTTP Response
Database Object → JSON
Repository Result → Response
```

特別關注：

```text
Password Hash
Token
Secret
Personal Information
Internal Status
Internal Remark
Audit Field
Internal Identifier
IP Address
Organization Internal Data
```

但不能只依敏感欄位名稱。

真正要回答：

> Consumer 是否真的需要這些欄位？

---

# 23. SEC-OUTPUT-002 — Data Minimization

優先模式：

```text
Entity
  ↓
Response DTO
  ↓
Required Fields Only
```

資料暴露策略應優先：

```text
ALLOWLIST
```

而不是：

```text
RETURN EVERYTHING
THEN BLOCK SOME FIELDS
```

直接回傳 Entity 應列入檢查候選，但不得單憑此點判定漏洞。

---

# 24. SEC-TENANT-001 — Tenant Isolation

如果系統存在：

```text
Tenant
Organization
Company
Agency
Department
Merchant
Partner
Client
```

隔離模型，確認 Query / Service 是否 Enforcement Tenant Boundary。

例如：

```text
findById(id)
```

可能需要進一步確認是否應為：

```text
findByIdAndTenant(id, trustedTenant)
```

核心攻擊情境：

```text
Tenant A Identity
       ↓
Tenant B Resource ID
       ↓
Access?
```

---

# 25. SEC-WORKFLOW-001 — Workflow Bypass

識別：

```text
DRAFT
PENDING
APPROVED
REJECTED
CANCELLED
COMPLETED
```

等 State Machine。

分析合法流程，例如：

```text
DRAFT
 ↓
PENDING
 ↓
APPROVED
```

是否能被繞成：

```text
DRAFT
 ↓
APPROVED
```

必須確認 Server 驗證：

```text
Current State
+
Requested Operation
```

---

# 26. SEC-WORKFLOW-002 — Client Controlled State

尋找：

```text
request.status
request.state
request.approved
```

直接控制重要 Domain State。

若 Client 能直接決定敏感狀態：

```text
POTENTIAL
```

並進一步追蹤 Service 驗證。

---

# 27. SEC-WORKFLOW-003 — Replay / Duplicate Operation

檢查：

```text
submit
approve
payment
transfer
issue
activate
redeem
send
create
```

重複執行的結果。

分析：

```text
Same Request
    ↓
Execute Twice
    ↓
What happens?
```

尋找：

```text
Idempotency
State Validation
Unique Constraint
Transaction Control
```

---

# 28. SEC-WORKFLOW-004 — Business Race Condition

尋找：

```text
READ
 ↓
CHECK
 ↓
UPDATE
```

分析兩個 Request 同時執行。

確認：

```text
Transaction
Optimistic Lock
Pessimistic Lock
Atomic Update
Unique Constraint
```

不得因存在 Transaction 就直接判定不存在 Race Condition。

---

# 29. SEC-DATA-001 — Sensitive Logging

檢查：

```text
Request Object
Response Object
Entity
HTTP Header
Authorization Header
JWT
Cookie
Session ID
Token
Password
Personal Data
```

是否被記錄。

例如：

```text
log(request)
```

必須展開 Request Object 欄位分析，而不是只分析 Logger Statement。

---

# 30. SEC-DATA-002 — Error Exposure

分析 HTTP Response 是否暴露：

```text
Exception Message
Stack Trace
SQL
Filesystem Path
Internal Host
Internal IP
Database Schema
Class Name
Token
Internal Identifier
```

同時追蹤：

```text
Global Exception Handler
Error Controller
Middleware Error Handler
Controller Advice
```

---

# 31. SEC-FILE-001 — File / Download Authorization

針對：

```text
/download/{id}
/file/{id}
/attachment/{id}
/export/{id}
```

確認：

```text
Authentication
Authorization
Ownership
Tenant
Business Permission
```

不能只確認 File Exists。

---

# 32. SEC-FILE-002 — Export Data Exposure

檢查：

```text
CSV
Excel
PDF
ZIP
Report
Batch Export
```

輸出的資料是否超過 Consumer 實際需要。

Export 必須同樣符合：

```text
Authorization
Ownership
Tenant Isolation
Data Minimization
```

---

# 33. SEC-API-001 — Legacy / Forgotten Endpoint

尋找：

```text
legacy
old
deprecated
test
debug
temp
backup
internal
admin
v1
```

以及 UI 已不使用但仍存在 Route 的 Endpoint。

必須區分：

```text
Unused by UI
```

與：

```text
Unreachable from Network
```

前者不能視為安全控制。

---

# 34. Repository / DAO Security Analysis

Repository 不只檢查 Injection。

同時確認 Query 是否缺少：

```text
ownerId
userId
tenantId
organizationId
status
permission boundary
```

但：

```text
findById(id)
```

本身不得直接判定為 IDOR。

必須結合：

```text
Controller
Service
Authentication Identity
Authorization
Ownership
Tenant
```

一起判斷。

---

# 35. Mandatory Attack Simulation

對重要 Endpoint 至少模擬：

```text
1. 修改 Resource ID
2. 修改 userId / accountId
3. 修改 tenantId / organizationId
4. 修改 role / permission
5. 修改 status
6. 加入 UI 沒有提供的 Request Field
7. 移除或偽造安全欄位
8. 重複 Request
9. 跳過 Workflow
10. 直接呼叫 UI 沒入口的 Endpoint
11. Normal User → Admin Endpoint
12. User A Token → User B Resource
13. Tenant A Token → Tenant B Resource
14. 修改 Download / Export ID
15. Concurrent Requests
```

Attack Simulation 是 Source Code Reasoning。

預設不得：

```text
Attack Production System
Send Real Malicious Request
Modify Real Data
```

---

# 36. False Positive Reduction Procedure

任何 Finding 在進入 CONFIRMED 前，必須完成以下 Verification。

## Step 1 — Search Local Control

確認目前方法是否已存在：

```text
Authentication
Authorization
Ownership Check
Tenant Check
State Validation
```

## Step 2 — Search Upstream Control

確認：

```text
Security Configuration
Gateway
Filter
Middleware
Interceptor
AOP
Annotation
Guard
Policy
```

## Step 3 — Search Downstream Control

確認：

```text
Service
Domain Service
Repository
DAO
Database Constraint
```

## Step 4 — Search Shared Security Utility

確認：

```text
Authorization Utility
Permission Service
ACL
RBAC Service
Security Helper
```

## Step 5 — Verify Actual Reachability

確認 Endpoint 是否真的：

```text
Mapped
Enabled
Reachable
```

## Step 6 — Verify Data Flow

確認 Client-controlled Data 是否真的能流向：

```text
Sensitive Operation
Sensitive Resource
Sensitive Response
```

完成以上步驟後才能提高 Confidence。

---

# 37. Important False Positive Rules

不得因：

```text
Controller 沒 @PreAuthorize
```

直接判定：

```text
Missing Authorization
```

不得因：

```text
findById(id)
```

直接判定：

```text
IDOR
```

不得因：

```text
Entity returned
```

直接判定：

```text
Sensitive Data Exposure
```

不得因：

```text
@Transactional
```

直接判定：

```text
No Race Condition
```

不得因：

```text
Frontend does not call endpoint
```

直接判定：

```text
Endpoint unreachable
```

不得因：

```text
Security Control Not Found
```

直接宣稱：

```text
Security Control Does Not Exist
```

---

# 38. Evidence Requirement

每個 Finding 必須至少包含一項可定位 Evidence：

```text
File
Class
Method
Endpoint
Relevant Code Path
```

高 Confidence Finding 應盡可能提供完整：

```text
Untrusted Input
      ↓
Controller
      ↓
Service
      ↓
Authorization Gap
      ↓
Repository
      ↓
Sensitive Operation / Response
```

沒有 Evidence 的猜測不得列為 CONFIRMED。

---

# 39. Finding Classification

Finding 必須分類：

```text
CONFIRMED
POTENTIAL
NEEDS_REVIEW
```

## CONFIRMED

Source Code 已提供足夠證據支持問題成立。

## POTENTIAL

存在合理攻擊路徑，但仍可能有未確認的控制。

## NEEDS_REVIEW

需要業務規則、外部系統或人工判斷才能確認。

---

# 40. Confidence

每個 Finding 標示：

```text
HIGH
MEDIUM
LOW
```

Confidence 表示：

```text
Evidence Completeness
```

不是：

```text
Business Severity
```

---

# 41. Severity Candidate and Finding Priority

每個 Finding **必須**標示 `Severity Candidate: CRITICAL / HIGH / MEDIUM / LOW / INFO`。這是初步處理優先順序，不是 AI 認定的最終弱點定級；最終等級須由人工依 Data Sensitivity、Exposure、Authentication Requirement、Authorization Boundary、Exploitability、Affected Population、Business Impact 與 Existing Controls 確認。不得只憑 Finding Category 固定定級，例如 IDOR、Mass Assignment 或 Excessive Data Exposure 不必然是 HIGH。

- **CRITICAL**：例如未授權存取高度敏感或大規模跨使用者／Tenant 資料、取得最高管理權限、執行高度敏感管理功能、重大完整性或權限邊界破壞。
- **HIGH**：例如已登入者存取他人重要敏感資料、越權執行敏感功能、Tenant 隔離失效、修改重要安全欄位、繞過重要審核流程。
- **MEDIUM**：例如有限範圍資料曝露、非核心功能授權不足、敏感日誌、錯誤資訊洩漏、受條件限制的業務邏輯弱點。
- **LOW**：例如影響有限、需要特殊前提、縱深防禦不足且無直接敏感資料或權限影響。
- **INFO**：例如沒有直接利用路徑的架構、安全強化或資料最小化建議。

Classification（第 39 節）與 Confidence（第 40 節）是獨立維度。`CRITICAL + POTENTIAL + MEDIUM Confidence` 只表示**若成立**可能有重大影響，不能稱為已確認重大弱點。

詳細 Finding 依 `CRITICAL → HIGH → MEDIUM → LOW → INFO` 排序；同級依 `CONFIRMED → POTENTIAL → NEEDS_REVIEW`，再依 `HIGH → MEDIUM → LOW` Confidence 排序。首頁「優先處理項目」作為行動佇列，依 `CRITICAL + CONFIRMED → HIGH + CONFIRMED → CRITICAL + POTENTIAL → HIGH + POTENTIAL` 顯示，並清楚標示尚待驗證者。

---

# 42. Required Finding Format

所有 Finding 使用以下結構，說明文字使用繁體中文：

```text
Finding ID:

Category:

Classification:
CONFIRMED / POTENTIAL / NEEDS_REVIEW

Severity Candidate:

Confidence:

Endpoint:

HTTP Method:

Affected Components:
-

Trust Boundary:

Authorization Boundary:

問題摘要:

Evidence:
- File:
- Class:
- Method:
- Relevant Code:

Data Flow:

HTTP Request
→
Security Layer
→
Controller
→
Service
→
Repository
→
Sensitive Operation / Response

Attack Scenario:
1.
2.
3.

Existing Security Controls:
-

Verification Performed:
-

Why Existing Controls May Be Insufficient:
-

Potential Impact:
-

Recommendation:
-

Need Human Confirmation:
YES / NO

Human Confirmation Questions:
-
```

欄位名稱可以保留上述標準英文，但欄位內容必須使用繁體中文。

---

# 43. Endpoint Security Matrix

報告必須包含 Endpoint Security Matrix，列出重要 Endpoint 及其安全控制證據；HTTP Method 應與 Endpoint 一併顯示。

| Endpoint | AuthN | AuthZ | Ownership | Tenant | Input | Output | Workflow | Finding |
|---|---|---|---|---|---|---|---|---|
| `GET /api/...` | YES/?/NO | YES/?/NO | YES/?/NO/N/A | YES/?/NO/N/A | YES/?/NO/N/A | YES/?/NO/N/A | YES/?/NO/N/A | Finding ID / — |

`YES` 表示找到該控制的 Enforcement Evidence；`NO` 表示已檢查相關路徑並確認所需控制不存在；`?` 表示證據不足；`N/A` 表示該 Endpoint 不適用。Input／Output 的 `YES` 指已確認相關欄位有適當限制，不能只因存在一般輸入驗證就標為 YES。對 `?` 說明未取得的證據，對 `NO` 提供可定位證據。**NOT FOUND != NOT IMPLEMENTED**。Finding 欄連結第 44 節的詳細 Finding。

---

# 44. Required Final HTML Report

Review 完成後，在 `reports/ai/security/` 建立或更新本次執行日期的 `security-review-report-YYYYMMDD.html`，此為唯一預設正式報告；目錄不存在時應先建立。檔名日期取自實際執行 Security Review 當日的執行環境當地日期，且須與報告內的 `Review Date` 一致。HTML 使用 `<!doctype html>`、`<html lang="zh-TW">`、UTF-8 與內嵌 `<style>`；可直接離線用 Browser 開啟、傳遞、封存、列印並另存 PDF。不得引用外部 CSS、JavaScript、CDN、字型、追蹤腳本、遠端資產或不必要動畫。所有從 Repository 讀取的文字與程式碼片段都必須先 HTML escape，證據以 `<pre><code>…</code></pre>` 表示；不得在報告洩漏憑證或真實機敏值。

Severity 的 CRITICAL／HIGH／MEDIUM／LOW／INFO 與 Classification 的 CONFIRMED／POTENTIAL／NEEDS_REVIEW 都須以**文字及視覺標籤**同時呈現，不能只靠顏色，以支援色弱、黑白列印與 PDF。版面需具清楚層級、可讀表格與程式碼；提供 Table of Contents、章節錨點與每個 Finding 的唯一錨點（如 `#SEC-001`）。優先清單及分類索引須連結至 Finding。使用 `@media print`，讓 Severity、Finding ID、標題、Evidence、Recommendation 列印後仍清楚。

## 44.1 HTML 章節與欄位

依下列順序產生；沒有 Finding 的分類仍保留並寫「本次檢視範圍內未識別出相關 Finding。」這不代表風險不存在。

1. **Report Header**：標題 `Source Code Security Review Report`、Project、Repository／Module、Review Date、Review Scope、Specification Version。
2. **Executive Dashboard**：總 Finding 數、CRITICAL／HIGH／MEDIUM／LOW／INFO 各級數量、CONFIRMED／POTENTIAL／NEEDS_REVIEW 各類數量；全部由詳細 Finding 計算。
3. **Executive Summary**：檢視目的、範圍、主要安全架構、Finding 總數、高風險項目、主要 Security Boundary 問題及限制；不得誇大或省略證據缺口。
4. **Priority Findings（優先處理項目）**：依第 41 節的行動佇列顯示 CRITICAL／HIGH Finding。每筆列 Finding ID、Severity Candidate、Classification、Confidence、Category、Endpoint／Component、繁體中文摘要與詳細連結。POTENTIAL 須標示尚待確認。
5. **Project Security Context**：Application Type、Framework、Authentication、Authorization、Tenant Model、Security Entry Points、Sensitive Domains、Critical Workflows；未知內容標 `UNKNOWN`。
6. **Authentication Architecture**：Identity Source、Authentication Mechanism、Session／Token／JWT、Trusted Identity Boundary、Security Filter／Middleware。
7. **Authorization Architecture**：RBAC／ABAC／ACL／Custom、Endpoint 與 Service Authorization、Resource Ownership、Tenant Boundary。
8. **Endpoint Security Matrix**：使用第 43 節的欄位與狀態。
9. **Findings by Severity**：CRITICAL、HIGH、MEDIUM、LOW、INFO 依序，各節顯示實際數量；同級依第 41 節排序，每筆完整呈現第 42 節所有欄位及繁體中文問題摘要。
10. **Findings by Category**：IDOR／BOLA、BFLA／Authorization、Tenant Isolation、Mass Assignment、Excessive Data Exposure、Workflow／Business Logic、Replay／Race Condition、Logging／Error Exposure、File／Export Security、Legacy Endpoint；只做簡短彙整與 ID 連結，不複製完整 Finding。其他類別若有 Finding 亦須列出。
11. **Needs Human Review**：集中列出 NEEDS_REVIEW 及其他必要人工確認項目；逐項說明已知 Evidence、缺少的資訊、應由誰確認、具體問題。
12. **Security Architecture Observations**：授權架構、安全邊界、DTO 設計、資料最小化、一致性、舊設計與 Defense in Depth 等沒有直接利用證據的觀察；不得與已確認漏洞混為一談。
13. **Human Review Checklist**：列出 Developer、Architect、Security Team、Business Owner、System Administrator 等應確認的具體問題。
14. **Review Limitations**：列出實際無法驗證的 Gateway、IdP、Production Configuration、Database Permission、External Authorization Service、Business Ownership Rule、Infrastructure Control 等，以及對結論的影響；不得假定外部控制存在或不存在。

## 44.2 Finding Detail

每筆至少顯示第 42 節列出的所有欄位與問題摘要。Evidence 應定位到 File、Class、Method、Relevant Code，可能時附行號。重要 Data Flow 僅描述有原始碼支持的實際路徑（HTTP Request → Security Layer → Controller → Service → Repository → Sensitive Operation／Response）；有未驗證步驟須標明。Recommendation 指明需在哪個授權邊界或元件補強，並提供可執行驗證方式，避免空泛的「加強安全」。

## 44.3 Report Integrity and Validation

產出後自行驗證：

- [ ] HTML 可作為 Standalone File 開啟，主要內容為繁體中文。
- [ ] 嚴重性依 CRITICAL → HIGH → MEDIUM → LOW → INFO，同級 CONFIRMED 在 POTENTIAL 前，Confidence 次序正確。
- [ ] Finding ID 唯一，章節及 Finding 錨點與目錄／索引連結有效。
- [ ] Dashboard 的 Severity 與 Classification Count 各自等於詳細 Finding 總數。
- [ ] Priority Findings、各 Severity 節數量、Category Summary 都引用相同 Finding；Category 可複選，但不得重複計入 Dashboard 總數。
- [ ] Endpoint Security Matrix 完整、Evidence 可定位，`?` 與 `NO` 不混淆。
- [ ] NEEDS_REVIEW／POTENTIAL 未被描述為已確認弱點；Review Limitations 已列出。
- [ ] 沒有引用外部資源，沒有在 HTML 插入未跳脫的來源文字，程式碼未因 Review 修改。

未完成驗證時不得宣稱完整檢視；在限制章節記錄未完成原因。

---

# 45. Review Limitations

Report 必須說明實際限制，例如：

```text
External Gateway configuration unavailable
Identity Provider configuration unavailable
Production environment configuration unavailable
Database permissions unavailable
Business ownership rule undocumented
External authorization service unavailable
```

不得把無法檢查的外部控制假設為存在或不存在。

---

# 46. SAST Complementary Model

本 Review 不應大量重複 SAST 已擅長的 Pattern。

## Traditional SAST / SCA

優先：

```text
SQL Injection
Command Injection
Path Traversal
XSS
XXE
Unsafe Deserialization
Hardcoded Secret
Weak Cryptography
Insecure Randomness
Resource Leak
Known Vulnerable Dependency
```

## AI Semantic Security Review

優先：

```text
IDOR / BOLA
BFLA
Resource Ownership
Tenant Isolation
Mass Assignment
Excessive Data Exposure
Workflow Bypass
Authorization Inconsistency
Replay
Business Race Condition
Fail-open
Legacy Endpoint
Business Sensitive Data Exposure
```

整體模型：

```text
                    Source Code
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
         SAST / SCA           AI Security Review
             │                       │
      Technical Patterns       Business Semantics
      Source / Sink            Authorization
      Known Weakness           Ownership
                               Workflow
                               Data Minimization
             │                       │
             └───────────┬───────────┘
                         ▼
                Combined Findings
                         │
                         ▼
                   Human Review
```

兩者互補，不互相取代。

---

# 47. Completion Criteria

AI 不得在以下工作未完成前宣告 Review 完成：

* [ ] Repository Context 已建立
* [ ] Application Architecture 已初步辨識
* [ ] Authentication 已分析
* [ ] Authorization 已分析
* [ ] Endpoint 已盤點
* [ ] Security Layer 已搜尋
* [ ] Controller → Service → Repository 已追蹤
* [ ] Resource Ownership 已檢查
* [ ] Tenant Boundary 已檢查
* [ ] Mass Assignment 已檢查
* [ ] Response Data Exposure 已檢查
* [ ] Workflow 已檢查
* [ ] Replay 已檢查
* [ ] Race Condition 已檢查
* [ ] Logging / Error Exposure 已檢查
* [ ] File / Export 已檢查
* [ ] Legacy Endpoint 已檢查
* [ ] Cross-endpoint Consistency 已比較
* [ ] Attack Simulation 已執行
* [ ] False Positive Verification 已執行
* [ ] Finding 已分類並標示 Severity Candidate、Confidence
* [ ] Human Review Items 已列出
* [ ] Review Limitations 已列出
* [ ] `reports/ai/security/security-review-report-YYYYMMDD.html` 已依本次執行日期建立或更新，主要內容為繁體中文（zh-TW）
* [ ] 報告檔名中的 `YYYYMMDD` 與報告內的 `Review Date` 一致
* [ ] 第 44.3 節的 HTML 報告完整性驗證已通過

無法檢視的項目應在報告說明範圍、原因及未能確認的結論；不得把未檢視寫成已完成。

---

# 48. Core Security Questions

對每個重要 Endpoint，AI 最終至少回答：

```text
1. Who are you?
   Authentication

2. Can you perform this operation?
   Authorization / BFLA

3. Can you access THIS resource?
   Ownership / IDOR / BOLA

4. Does this resource belong to your security boundary?
   Tenant Isolation

5. Which fields can the Client control?
   Mass Assignment

6. Which fields should the Client receive?
   Excessive Data Exposure

7. Can required workflow states be bypassed?
   Workflow Bypass

8. What happens if the request executes twice?
   Replay / Idempotency

9. What happens if requests execute concurrently?
   Business Race Condition

10. What happens when security verification fails?
    Fail-open / Fail-closed
```

無法回答：

```text
NEEDS_REVIEW
```

不得猜測。

---

# 49. Project-specific Extension

如果某個 Repository 有特殊 Security Architecture，可另外建立：

```text
docs/security-review-project.md
```

例如：

```text
Trusted Identity Source:
<...>

Trusted Headers:
<...>

Authentication Architecture:
<...>

Role / Permission Model:
<...>

Tenant Boundary:
<...>

Resource Ownership Rules:
<...>

Sensitive Entities:
<...>

Sensitive Fields:
<...>

Critical Workflows:
<...>

Critical Endpoints:
<...>

Known Security Exceptions:
<...>
```

此檔案為：

```text
OPTIONAL
```

若不存在：

> AI 必須繼續從 Source Code 建立 Security Context。

---

# 50. Repository Versioning

本次規格異動：Version 2.1；Date: 2026-09-21；Change: Security Review 報告統一輸出至 `reports/ai/security/`，並以實際執行日期命名為 `security-review-report-YYYYMMDD.html`；Reason: 統一報告位置、保留不同日期的檢視結果，並讓檔名可直接辨識執行日期。

前次規格異動：Version 2.0；Date: 2026-09-18；Change: 保留原始 52 節安全檢視規則，整合 Severity Candidate 排序與離線 HTML 正式報告；Reason: 讓資安與開發人員能依初步風險優先檢視，並保留完整原始碼證據。

本文件應與 Source Code 一起進行版本控制。

Security Review 規則異動應透過正常：

```text
Pull Request
Code Review
Commit History
```

管理。

建議重大規則異動記錄：

```text
Version:
Date:
Change:
Reason:
```

例如：

```text
Version: 1.1

Change:
Added Tenant Isolation Review

Reason:
Cross-tenant access risk identified during manual review.
```

未來若人工檢視、SAST、滲透測試或實際事件發現新的「AI 應固定檢查」模式，應優先將規則加入本文件，而不是只存在於單次 Prompt。

---

# 51. Minimal User Instruction

本文件放在 Repository 的 `docs/security-review.md` 後，使用者最低只需下：

```text
請執行 docs/security-review.md
```

AI／Coding Agent 應自行讀規格、建立 Repository 與 Security Context、盤點 Endpoint、追蹤 Controller → Service → Repository、執行安全檢查與靜態 Attack Simulation、降低誤報、分類 Finding、評估 Severity Candidate、排序，並依執行當日日期產生及驗證 `reports/ai/security/security-review-report-YYYYMMDD.html`。

不得要求使用者重新提供本文件已定義的掃描方式、項目、誤報規則、Severity 排序、Finding 格式、HTML 格式、報告檔名與語言；只有專案特定且無法從 Repository 確認的資訊才列為人工確認問題。

---

# 52. Guiding Principle

本 Security Review 的核心是建立足夠的 Source Code Evidence，判斷不可信任的 Client 是否能跨越本應存在的 Security Boundary。AI 應 Discover、Trace、Reason、Verify、Report；不得 Guess、Assume、Over-report。

最終預設產出 `reports/ai/security/security-review-report-YYYYMMDD.html`，其中 `YYYYMMDD` 為實際執行 Security Review 當日日期，並與報告內的 `Review Date` 一致。主要內容使用繁體中文（zh-TW）；技術術語、Source Identifier、Endpoint、Class、Method、Field 與程式碼維持原始名稱。

---
