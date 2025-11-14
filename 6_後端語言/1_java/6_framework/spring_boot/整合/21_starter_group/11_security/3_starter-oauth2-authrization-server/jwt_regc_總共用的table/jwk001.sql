-- jwk_key 當前 jwk 使用狀況
CREATE TABLE jwk001 (
  id                BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT df_jwk001_id PRIMARY KEY,
  kid               VARCHAR(128) NOT NULL,         -- 對外唯一 Key ID
  issuer            VARCHAR(200) NOT NULL,         -- e.g. https://auth.example.com
  purpose           VARCHAR(8)  NOT NULL,          -- 'sig' or 'enc'，一般jwt都是 sig；若有特定需求是 JWE 則就是用 enc
  alg               VARCHAR(32)  NOT NULL,         -- 'RS256','ES256','EdDSA'...
  kty               VARCHAR(16)  NOT NULL,         -- 'RSA','EC','OKP'...
  state             TINYINT       NOT NULL,        -- 1=ACTIVE, 2=PRE_ACTIVE, 4=TRANSITION, 9=INACTIVE, 99=COMPROMISED
  public_jwk        VARCHAR(MAX) NOT NULL,         -- 僅公鑰部分 (供 JWKS)
  -- 私鑰託管二選一：應用層加密後的 PKCS#8 或 HSM/KMS 參考
  private_pkcs8     VARBINARY(MAX) NULL,            -- 存密文（建議 AES-GCM 封裝）
  -- private_key_ref   VARCHAR(256)  NULL,          -- 未來有 HSM/KMS/Vault 來源時用
  -- 資料來源範例:
  --   pkcs11:token=HSM1;slot-id=1;object=auth-rsa;type=private（HSM/PKCS#11）
  --   aws-kms:arn:aws:kms:ap-northeast-1:123456789012:key/abcd-...
  --   gcp-kms:projects/p/locations/l/keyRings/r/cryptoKeys/k/cryptoKeyVersions/1
  --   azure-kv:https://myvault.vault.azure.net/keys/jwk-signing/abcd1234
  --   vault:kv/auth/jwk/signing?version=3

  not_before        DATETIME2(3)   NULL,
  not_after         DATETIME2(3)   NULL,
  activated_at      DATETIME2(3)   NULL,
  grace_until       DATETIME2(3)   NULL,
  disabled_at       DATETIME2(3)   NULL,
  created_at        DATETIME2(3)   NOT NULL DEFAULT SYSUTCDATETIME(),
  comment           VARCHAR(1000) NULL
);
CREATE INDEX jwk001_s1_key ON jwk001(issuer, kid);
CREATE INDEX jwk001_s2_key ON jwk001(issuer, purpose, alg) WHERE state = 4; -- JwkState.TRANSITION 對應常數
CREATE INDEX jwk001_s3_key ON jwk001(issuer, purpose, alg) WHERE state = 1; -- JwkState.ACTIVE 對應常數


-- 快查目前可對外發布的鍵（ACTIVE/GRACE 內、尚未 not_after）：
--CREATE INDEX IX_jwk_publishable
--ON dbo.jwk_key(issuer, state, not_after)
--INCLUDE (kid, public_jwk);

-- 常用查詢：目前 ACTIVE 的鍵
--CREATE INDEX IX_jwk_active ON dbo.jwk_key(issuer) WHERE state = 1;
