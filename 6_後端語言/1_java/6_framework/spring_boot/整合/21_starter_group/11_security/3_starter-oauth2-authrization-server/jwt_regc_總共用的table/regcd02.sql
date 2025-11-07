-- oauth2_registered_client 之額外明細 oauth2_client_grant_type
CREATE TABLE IF NOT EXISTS regcd02 ( -- spring-security-oauth2-authorization-server.RegisteredClient.Set<AuthorizationGrantType> authorizationGrantTypes
  issuer      	VARCHAR(200) NOT NULL,
  rc_id   		VARCHAR(100) NOT NULL,
  grant_type  	VARCHAR(50)  NOT NULL,
  created_at	DATETIME2(3) NOT NULL     		-- UTC

  -- CONSTRAINT FK_grant_type_client FOREIGN KEY (issuer, rc_id)
  -- 	REFERENCES oauth2_registered_client (issuer, rc_id)
);
CREATE UNIQUE INDEX regcd02_p_key ON regcd02(issuer, rc_id, grant_type);