## developer_access
- open adminuser pgadmin4 and run the following
```sh
-- 1. Create the role with login capability
CREATE ROLE developer_access WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    PASSWORD 'Bo#VnTw&1QKmpX_t'; 

-- 2. Grant database connection
GRANT CONNECT ON DATABASE inlogicai_public TO developer_access;

-- 3. Grant schema creation privileges
GRANT CREATE ON DATABASE inlogicai_public TO developer_access;

-- 4. For existing schemas (like public):
GRANT USAGE, CREATE ON SCHEMA public TO developer_access;

-- 5. For existing tables:
GRANT
SELECT,
INSERT,
UPDATE,
DELETE,
TRUNCATE
ON ALL TABLES IN SCHEMA public
TO developer_access;

-- 6. For sequences (auto-increment columns):
GRANT
USAGE,
SELECT,
UPDATE
ON ALL SEQUENCES IN SCHEMA public
TO developer_access;

-- 7. For future tables in existing schemas:
ALTER DEFAULT PRIVILEGES
IN SCHEMA public
GRANT
SELECT,
INSERT,
UPDATE,
DELETE,
TRUNCATE
ON TABLES TO developer_access;

ALTER DEFAULT PRIVILEGES
IN SCHEMA public
GRANT
USAGE,
SELECT,
UPDATE
ON SEQUENCES TO developer_access;
GRANT USAGE ON SCHEMA public TO developer_access;
GRANT CREATE ON SCHEMA public TO developer_access;
```
- Check schema creation capability
```sh
SELECT has_database_privilege(
    'developer_access',
    'inlogicai_public',
    'CREATE'
);

SELECT 
    has_schema_privilege('developer_access', 'public', 'USAGE') AS usage_priv,
    has_schema_privilege('developer_access', 'public', 'CREATE') AS create_priv;

```
- password reset
```sh
ALTER ROLE developer_access WITH PASSWORD 'Kb^YmQt$6JZpiV_a';
```

## readonly_access