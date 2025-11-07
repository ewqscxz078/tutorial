-- oauth2_registered_client 之額外明細 oauth2_client_scope
CREATE TABLE IF NOT EXISTS regcd05 (						-- spring-security-oauth2-authorization-server.RegisteredClient.Set<String> scopes
  issuer    VARCHAR(200) NOT NULL,
  rc_id     VARCHAR(100) NOT NULL,
  scope     VARCHAR(100) NOT NULL,
  created_at	DATETIME2(3)     NOT NULL     		-- UTC
  -- CONSTRAINT FK_scope_client FOREIGN KEY (issuer, rc_id)
  -- 	REFERENCES oauth2_registered_client (issuer, rc_id)
);
CREATE UNIQUE INDEX regcd05_p_key ON regcd05(issuer, rc_id, scope);