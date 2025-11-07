-- oauth2_token_settings
CREATE TABLE IF NOT EXISTS regc003 (
  issuer                               VARCHAR(200)  NOT NULL,
  rc_id                                 VARCHAR(100)  NOT NULL,   -- FK -> oauth2_registered_client(issuer, rc_id)

  access_token_ttl_iso                  VARCHAR(40),             -- = TokenSettings.accessTokenTimeToLive
  refresh_token_ttl_iso                 VARCHAR(40),             -- = TokenSettings.refreshTokenTimeToLive
  reuse_refresh_tokens                  SMALLINT,                -- = TokenSettings.reuseRefreshTokens
  authorization_code_ttl_iso            VARCHAR(40),             -- = TokenSettings.authorizationCodeTimeToLive
  device_code_ttl_iso                   VARCHAR(40),             -- = TokenSettings.deviceCodeTimeToLive
  id_token_signature_alg                VARCHAR(50),             -- = TokenSettings.idTokenSignatureAlgorithm（例如 RS256, ES256）
  access_token_format                   VARCHAR(50),             -- = TokenSettings.accessTokenFormat（例如 self-contained / reference）

  x509_cert_bound_access_tokens         SMALLINT      NOT NULL DEFAULT 0,   -- = TokenSettings.x509CertificateBoundAccessTokens（若用得到）

  -- 預留擴充：放 SAS 新增或自訂的 token setting
  extra_json                            TEXT,				 -- 若要正規化可考慮 oauth2_token_setting_kv

  created_at                            DATETIME2(3)        NOT NULL,
  updated_at                            DATETIME2(3)        NOT NULL


  -- CONSTRAINT FK_oauth2_token_settings_client
  --   FOREIGN KEY (issuer, rc_id)
  --     REFERENCES oauth2_registered_client(issuer, rc_id)
);
CREATE UNIQUE INDEX regc003_p_key ON regc003(issuer, rc_id);