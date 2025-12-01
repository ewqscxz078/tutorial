-- 宣告 registered_client.authMethods 為 private_key_jwt 用
-- oauth2_registered_client_jwk（regkj01）使用紀錄
CREATE TABLE regkj01 (
  issuer          VARCHAR(200) NOT NULL,
  rc_id           VARCHAR(100) NOT NULL,
  ver             INTEGER      NOT NULL,        -- 1,2,3…（版本）
  kid             VARCHAR(128) NOT NULL,        -- 對外用的 kid

  public_jwk      VARCHAR(MAX) NOT NULL,        -- 只含公鑰
  private_jwk_enc VARBINARY(MAX) NOT NULL,      -- AES-GCM 加密後的私鑰 JWK（或 VARCHAR(MAX) Base64）

  state           SMALLINT     NOT NULL,        -- 0=INACTIVE,1=ACTIVE,2=PREV_ACTIVE,9=COMPROMISED
  issued_at       DATETIME2(3) NOT NULL,
  expires_at      DATETIME2(3) NULL,
  disabled_at     DATETIME2(3) NULL,
  grace_until     DATETIME2(3) NULL,

  created_at      DATETIME2(3) NOT NULL,
  updated_at      DATETIME2(3) NOT NULL
);
CREATE UNIQUE INDEX regkj01_p_key ON regkj01(issuer, rc_id, ver);

CREATE INDEX regkj01_s1_key ON regkj01(issuer, rc_id, state);

CREATE INDEX regkj01_s2_key ON regkj01(issuer, kid);
