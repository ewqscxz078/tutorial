-- oauth2_registered_client_policy
CREATE TABLE regcp01 (
  issuer                   VARCHAR(200) NOT NULL,
  rc_id                    VARCHAR(100) NOT NULL,   -- FK → registered_client
  auto_rotate              SMALLINT     NOT NULL,   -- 0/1
  rotation_interval_iso    VARCHAR(40)  NOT NULL,   -- e.g. 'P90D'
  overlap_grace_iso        VARCHAR(40)  NOT NULL,   -- e.g. 'P14D' 舊密鑰可用的重疊期
  secret_max_age_iso       VARCHAR(40)  NOT NULL,   -- e.g. 'P180D'（上限）
  max_secrets_retained     INTEGER      NOT NULL,   -- e.g. 5（保留多少舊版）
  secret_hash_algo         VARCHAR(32)  NOT NULL,   -- 'bcrypt' / 'argon2id' / 'scrypt'
  secret_generated_length  INTEGER      NOT NULL,   -- 產生新 secret 的長度（如 48/64）
  reuse_cooldown_iso       VARCHAR(40)  NULL,       -- e.g. 'P365D' 禁止重複使用期限
  last_rotated_at          DATETIME2(3)    NULL,       -- UTC
  next_rotate_at           DATETIME2(3)    NULL,       -- UTC
  created_at               DATETIME2(3)    NOT NULL,
  updated_at               DATETIME2(3)    NOT NULL
);
CREATE UNIQUE INDEX regcp01_p_key ON regcp01(issuer, rc_id);


-- CONSTRAINT FK_rc_policy FOREIGN KEY (issuer, rc_id)
--   REFERENCES oauth2_registered_client (issuer, rc_id)
 
--  allowed_auth_methods     VARCHAR(200) NULL,       -- 逗號分隔: 'client_secret_basic,client_secret_post'
