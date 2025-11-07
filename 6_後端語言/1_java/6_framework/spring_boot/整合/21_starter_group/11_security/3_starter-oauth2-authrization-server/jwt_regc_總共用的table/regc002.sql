-- oauth2_client_settings
CREATE TABLE IF NOT EXISTS regc002 (
  issuer                                VARCHAR(200)  NOT NULL,
  rc_id                                 VARCHAR(100)  NOT NULL,  -- FK -> oauth2_registered_client(issuer, rc_id)

  require_pkce                          SMALLINT      NOT NULL DEFAULT 0,   -- = ClientSettings.requireProofKey
  require_consent                       SMALLINT      NOT NULL DEFAULT 1,   -- = ClientSettings.requireAuthorizationConsent
  jwk_set_url                           VARCHAR(400),                      -- = ClientSettings.jwkSetUrl
  token_endpoint_auth_sign_alg          VARCHAR(50),                       -- = ClientSettings.tokenEndpointAuthenticationSigningAlgorithm
  x509_certificate_subject_dn			VARCHAR(400),                      -- = ClientSettings.x509CertificateSubjectDn

  -- 預留擴充：放 SAS 新增或自訂的 client setting
  extra_json                            TEXT,                           -- JSON字串（可選），若要正規化可考慮 oauth2_client_setting_kv (合放「罕用、供應商特有、不需查詢/比對/唯一約束」的設定。例如 UI 類提示、相容性旗標、你自家 Starter 想透傳給下游但不影響安全決策的東西)

  created_at                            DATETIME2(3)        NOT NULL,
  updated_at                            DATETIME2(3)        NOT NULL

  -- CONSTRAINT FK_oauth2_client_settings_client
  -- 	FOREIGN KEY (issuer, rc_id)
  --   REFERENCES oauth2_registered_client(issuer, rc_id)
);
CREATE UNIQUE INDEX regc002_p_key ON regc002(issuer, rc_id);