-- 宣告 registered_client.authMethods 為 private_key_jwt 用
-- oauth2_registered_client_key_policy（regkp01）
CREATE TABLE regkp01 (
  issuer                VARCHAR(200) NOT NULL,
  rc_id                 VARCHAR(100) NOT NULL,

  auto_rotate           SMALLINT     NOT NULL,   -- 0/1
  rotation_interval_iso VARCHAR(40)  NOT NULL,   -- e.g. 'P90D'
  overlap_grace_iso     VARCHAR(40)  NOT NULL,   -- 舊 key 的重疊期
  key_max_age_iso       VARCHAR(40)  NOT NULL,   -- e.g. 'P180D'
  max_keys_retained     INTEGER      NOT NULL,   -- e.g. 5
  reuse_cooldown_iso    VARCHAR(40)  NULL,       -- 禁止重複使用的冷卻期

  key_alg               VARCHAR(32)  NOT NULL,   -- 'RS256', 'ES256', 'EdDSA'...
  key_kty               VARCHAR(16)  NOT NULL,   -- 'RSA', 'EC', 'OKP'...
  key_size_bits         INTEGER      NULL,       -- RSA 長度；EC/OKP 可為 NULL
  key_use               VARCHAR(8)   NOT NULL,   -- 'sig'（client-auth 一般都是簽章用）

  last_rotated_at       DATETIME2(3) NULL,
  next_rotate_at        DATETIME2(3) NULL,
  created_at            DATETIME2(3) NOT NULL,
  updated_at            DATETIME2(3) NOT NULL
);

CREATE UNIQUE INDEX regkp01_p_key ON regkp01(issuer, rc_id);
