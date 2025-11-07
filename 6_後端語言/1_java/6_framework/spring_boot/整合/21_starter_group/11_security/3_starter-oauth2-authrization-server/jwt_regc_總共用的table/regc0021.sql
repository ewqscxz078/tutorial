-- client_setting 之 擴充 oatuh2_client_resource_indicator 
CREATE TABLE IF NOT EXISTS regc0021 (
  issuer   VARCHAR(200) NOT NULL,
  rc_id    VARCHAR(100) NOT NULL,
  uri      VARCHAR(400) NOT NULL,               -- 拿 Token 來打的那個資源的識別子
  created_at	DATETIME2(3)     NOT NULL     		-- UTC

  -- CONSTRAINT FK_resind_client FOREIGN KEY (issuer, rc_id)
  --	REFERENCES oauth2_registered_client (issuer, rc_id)
);

CREATE UNIQUE INDEX regc0021_p_key ON regc0021(issuer, rc_id, uri);