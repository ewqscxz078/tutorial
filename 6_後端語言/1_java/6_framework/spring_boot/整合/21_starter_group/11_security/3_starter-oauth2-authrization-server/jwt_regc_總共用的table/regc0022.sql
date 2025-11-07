-- client_setting 之 擴充 oauth2_client_audience
CREATE TABLE IF NOT EXISTS regc0022 (
  issuer   VARCHAR(200) NOT NULL,
  rc_id    VARCHAR(100) NOT NULL,
  aud      VARCHAR(200) NOT NULL,                   -- 一律代表要打的資源
  created_at	DATETIME2(3)     NOT NULL     		-- UTC

  -- CONSTRAINT FK_aud_client FOREIGN KEY (issuer, rc_id)
  --	REFERENCES oauth2_registered_client (issuer, rc_id)
);
CREATE UNIQUE INDEX regc0022_p_key ON regc0022(issuer, rc_id, aud);