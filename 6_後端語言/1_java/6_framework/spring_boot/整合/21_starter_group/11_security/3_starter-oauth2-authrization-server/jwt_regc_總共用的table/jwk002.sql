-- jwks_meta jwk 版本狀況
CREATE TABLE IF NOT EXISTS jwk002 (
  issuer         VARCHAR(200) NOT NULL,
  purpose        VARCHAR(8)    NOT NULL,         -- 'SIG' | 'ENC'
  alg            VARCHAR(32)  NOT NULL DEFAULT '__ANY__',
  jwks_hash      VARCHAR(100)  NULL;             -- 例: 'sha256:AbCd...'(base64url, 無 '=')
  last_modified  DATETIME2(3)  NOT NULL DEFAULT SYSUTCDATETIME(),
  key_count      INT           NOT NULL DEFAULT 0

);

CREATE UNIQUE INDEX jwk002_p_key ON jwk002(issuer, purpose, alg);