-- oauth2_registered_client
CREATE TABLE IF NOT EXISTS regc001 (
  issuer                    VARCHAR(200) NOT NULL,      -- 由於環境架構跨區多一個 issuer，需要區別用
  rc_id                     VARCHAR(100) NOT NULL,      -- spring-security-oauth2-authorization-server.RegisteredClient.id，UUID 字串

  client_id                 VARCHAR(100)  NOT NULL,     -- 對應 spring-security-oauth2-authorization-server.RegisteredClient.clientId，一律代表申請 token 的那一方（A 或 Gateway，如果是 Gateway 發起的交換）
  client_name               VARCHAR(200)  NOT NULL,     -- spring-security-oauth2-authorization-server.RegisteredClient.clientName
  client_id_issued_at       DATETIME2(3)  NOT NULL,     -- spring-security-oauth2-authorization-server.RegisteredClient.clientIdIssuedAt，UTC
  client_secret_hash        VARCHAR(200)  NULL,         -- spring-security-oauth2-authorization-server.RegisteredClient.clientSecret
  client_secret_expires_at  DATETIME2(3)  NULL,         -- spring-security-oauth2-authorization-server.RegisteredClient.clientSecretExpiresAt，UTC

  created_at                DATETIME2(3)  NOT NULL,     -- UTC
  updated_at                DATETIME2(3)  NOT NULL,     -- UTC
  enabled                   SMALLINT      NOT NULL,     -- 0/1
  client_notes              TEXT          NULL

);
CREATE UNIQUE INDEX regc001_p_key ON regc001(issuer, rc_id);
CREATE INDEX regc001_s1_key ON regc001(issuer, client_id);


-- 主鍵：(issuer, rc_id)
-- 唯一鍵：(issuer, client_id)
-- （可選）全域唯一：對 rc_id 加一個 UNIQUE（若保證 rc_id 以 UUID 產生且希望全域唯一）
-- 索引：針對常見過濾與維運工單設置覆蓋索引
-- 可選：若想強制 rc_id 全域唯一（跨 issuer 也唯一），再加一條 Unique
-- CONSTRAINT UX_oauth2_rc_rcid UNIQUE (rc_id),

-- 資料品質約束 :
-- CONSTRAINT CK_oauth2_rc_enabled CHECK (enabled IN (0, 1)),

-- 資料品質約束 : 若沒有 secret，則不應該有 expires_at（避免孤兒值）
-- CONSTRAINT CK_oauth2_rc_secret_exp
-- CHECK (client_secret_hash IS NOT NULL OR client_secret_expires_at IS NULL),

-- 資料品質約束 : updated_at 不得早於 created_at（通用寫法）
-- CONSTRAINT CK_oauth2_rc_time_order CHECK (updated_at >= created_at)