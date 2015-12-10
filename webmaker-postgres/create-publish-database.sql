CREATE ROLE publish WITH SUPERUSER LOGIN PASSWORD 'publish';
ALTER ROLE publish SET search_path=publish;

CREATE SCHEMA publish;
