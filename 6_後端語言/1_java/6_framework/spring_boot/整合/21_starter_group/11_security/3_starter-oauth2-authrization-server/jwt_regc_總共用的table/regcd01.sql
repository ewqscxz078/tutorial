-- oauth2_registered_client 之額外明細 oauth2_client_auth_method
CREATE TABLE IF NOT EXISTS regcd01 ( -- spring-security-oauth2-authorization-server.RegisteredClient.Set<ClientAuthenticationMethod> clientAuthenticationMethods
  issuer    	VARCHAR(200) NOT NULL,
  rc_id 		VARCHAR(100) NOT NULL,
  auth_method	VARCHAR(64)  NOT NULL,          -- client_secret_basic / private_key_jwt / ...
  created_at	DATETIME2(3) NOT NULL     		-- UTC

  -- CONSTRAINT FK_cam_client FOREIGN KEY (issuer, rc_id)
  --   REFERENCES oauth2_registered_client (issuer, rc_id)
);

CREATE UNIQUE INDEX regcd01_p_key ON regcd01(issuer, rc_id, auth_method);