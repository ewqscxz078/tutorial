--  oauth2_registered_client 之 client secret 歷史紀錄 oauth2_registered_client_secret
CREATE TABLE regcs01 (
  issuer          VARCHAR(200) NOT NULL,
  rc_id           VARCHAR(100) NOT NULL,
  ver             INTEGER      NOT NULL,          -- 1,2,3…（版本序號）
  secret_hash     VARCHAR(200) NOT NULL,
  issued_at       DATETIME2(3)    NOT NULL,          -- 生效時間（UTC）
  expires_at      DATETIME2(3)    NULL,              -- 到期（UTC）
  disabled_at     DATETIME2(3)    NULL,              -- 停用（UTC）
  grace_until     DATETIME2(3)    NULL,              -- 舊版可用到（UTC）
  state           SMALLINT     NOT NULL,          -- 0=INACTIVE,1=ACTIVE,2=PREV_ACTIVE,9=COMPROMISED
  created_at      DATETIME2(3)    NOT NULL,
  updated_at      DATETIME2(3)    NOT NULL

);
CREATE UNIQUE INDEX regcs01_p_key ON regcs01(issuer, rc_id, ver);
CREATE INDEX regcs01_s1_key ON regcs01(issuer, rc_id, state);



-- CONSTRAINT FK_secret_parent FOREIGN KEY (issuer, rc_id)
--   REFERENCES oauth2_registered_client (issuer, rc_id)