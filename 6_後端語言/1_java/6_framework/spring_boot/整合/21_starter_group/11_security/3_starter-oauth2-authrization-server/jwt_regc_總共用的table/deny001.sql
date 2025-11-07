-- jwk_denylist
CREATE TABLE IF NOT EXISTS deny001 ( 
	id          BIGINT IDENTITY(1,1) NOT NULL CONSTRAINT df_deny001_id PRIMARY KEY,
	issuer      VARCHAR(200) NOT NULL,       -- 哪個 Auth Server 的金鑰
	kid         VARCHAR(128) NOT NULL,       -- JWK 的 Key ID
	reason      VARCHAR(200) NULL,           -- 封鎖原因 (compromised, retired, manual)
	created_at  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
	expires_at  DATETIME2 NULL               -- 可選，封鎖期限 (e.g. grace 過後自動清掉)
);
CREATE UNIQUE INDEX deny001_p_key ON deny001(id);
CREATE INDEX deny001_s1_key ON deny001(issuer, kid);