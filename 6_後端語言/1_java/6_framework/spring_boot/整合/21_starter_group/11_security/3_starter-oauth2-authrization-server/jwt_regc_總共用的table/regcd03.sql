-- oauth2_registered_client 之額外明細 oauth2_client_redirect_uri
CREATE TABLE IF NOT EXISTS regcd03 ( -- spring-security-oauth2-authorization-server.RegisteredClient.Set<String> redirectUris
  issuer       	VARCHAR(200) NOT NULL,
  rc_id    		VARCHAR(100) NOT NULL,
  redirect_uri 	VARCHAR(500) NOT NULL,
  created_at	DATETIME2(3) NOT NULL     		-- UTC

  -- CONSTRAINT FK_redirect_client FOREIGN KEY (issuer, rc_id)
  -- 	REFERENCES oauth2_registered_client (issuer, rc_id)
);
CREATE UNIQUE INDEX regcd03_p_key ON regcd03(issuer, rc_id, redirect_uri);