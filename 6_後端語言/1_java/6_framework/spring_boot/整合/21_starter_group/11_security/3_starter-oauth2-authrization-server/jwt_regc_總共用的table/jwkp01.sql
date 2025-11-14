-- jwk_rotation_policy
CREATE TABLE jwkp01 (
  id                      BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT df_jwkp01_id PRIMARY KEY,
  issuer                  VARCHAR(200) NOT NULL,        -- e.g. https://auth.example.com
  purpose                 VARCHAR(8)   NOT NULL,        -- 'sig' | 'enc' | 'auth'
  alg                     VARCHAR(32)  NOT NULL,        -- 'RS256' | 'ES256' | 'EdDSA' ...
  kty                     VARCHAR(16)  NOT NULL,        -- 'RSA' | 'EC' | 'OKP' ...

  -- ISO-8601 duration literals (PT30M / PT2H / P1D ...)
  rotation_interval_iso   VARCHAR(40)  NOT NULL DEFAULT 'P1D',
  transition_iso          VARCHAR(40)  NOT NULL DEFAULT 'P7D',
  prev_active_iso         VARCHAR(40)  NOT NULL DEFAULT 'P7D',
  overlap_grace_iso       VARCHAR(40)  NOT NULL DEFAULT 'PT48H',

  -- Use SMALLINT(0/1) for booleans to maximize portability
  auto_rotate             SMALLINT     NOT NULL DEFAULT 1,
  max_keys_retained       INT          NOT NULL DEFAULT 6,

  inactive_retention_iso  VARCHAR(40)  NOT NULL DEFAULT 'P90D',  -- inactive 狀態保留多久
  wipe_private_key_only   SMALLINT     NOT NULL DEFAULT 1,       -- 刪除什錦清除私鑰欄位還是刪除整筆

  last_rotated_at         DATETIME2(3)    NULL,
  next_rotate_at          DATETIME2(3)    NULL,            -- 一般塞入應為 當前時間 + rotation_interval_iso

  created_at              DATETIME2(3)    NOT NULL DEFAULT SYSUTCDATETIME(),
  updated_at              DATETIME2(3)    NOT NULL DEFAULT SYSUTCDATETIME()

);
CREATE INDEX jwkp01_s1_key ON jwkp01(issuer, purpose, alg);

-- lightweight validations
-- CONSTRAINT ck_jrp_bool_auto_rotate
-- CHECK (auto_rotate IN (0, 1)),
-- CONSTRAINT ck_jrp_bool_wipe_only
-- CHECK (wipe_private_key_only IN (0, 1)),
-- CONSTRAINT ck_jrp_purpose
-- CHECK (purpose IN ('sig', 'enc')),
-- CONSTRAINT ck_jrp_rotation_interval_iso
-- CHECK (rotation_interval_iso LIKE 'P%'),
-- CONSTRAINT ck_jrp_transition_iso
-- CHECK (transition_iso LIKE 'P%'),
-- CONSTRAINT ck_jrp_prev_active_iso
-- CHECK (prev_active_iso LIKE 'P%'),
-- CONSTRAINT ck_jrp_overlap_grace_iso
-- CHECK (overlap_grace_iso LIKE 'P%')

-- Common secondary indexes
-- CREATE INDEX ix_jrp_issuer ON jwk_rotation_policy (issuer);

-- Portable substitute for a filtered index:
-- Query can use WHERE auto_rotate = 1 AND next_rotate_at IS NOT NULL
-- and still benefit from this composite index.
-- CREATE INDEX ix_jrp_due ON jwk_rotation_policy (auto_rotate, next_rotate_at);