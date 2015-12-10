ALTER ROLE webmaker SET search_path=webmaker;

CREATE SCHEMA webmaker;

/* Table Creation */
CREATE TABLE IF NOT EXISTS webmaker.users
(
  id bigint NOT NULL,
  username varchar NOT NULL,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL,
  language varchar NOT NULL DEFAULT 'en-US',
  moderator boolean NOT NULL DEFAULT FALSE,
  staff boolean NOT NULL DEFAULT FALSE,
  CONSTRAINT users_id_pk PRIMARY KEY (id),
  CONSTRAINT unique_username UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS webmaker.projects
(
  id bigserial NOT NULL,
  user_id bigint REFERENCES users(id),
  remixed_from bigint DEFAULT NULL,
  version varchar NOT NULL,
  title varchar NOT NULL,
  featured boolean NOT NULL DEFAULT FALSE,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL,
  thumbnail jsonb NOT NULL DEFAULT '{}'::JSONB,
  description text NOT NULL DEFAULT '',
  metadata jsonb DEFAULT '{"tags":[]}'::jsonb,
  CONSTRAINT projects_id_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS webmaker.pages
(
  id bigserial NOT NULL,
  project_id bigint REFERENCES webmaker.projects(id),
  user_id bigint REFERENCES webmaker.users(id),
  x integer NOT NULL,
  y integer NOT NULL,
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL,
  styles jsonb NOT NULL DEFAULT '{}'::JSONB,
  CONSTRAINT pages_id_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS webmaker.elements
(
  id bigserial NOT NULL,
  type varchar NOT NULL,
  page_id bigint REFERENCES webmaker.pages(id),
  user_id bigint REFERENCES webmaker.users(id),
  created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at timestamp DEFAULT NULL,
  attributes jsonb NOT NULL DEFAULT '{}'::JSONB,
  styles jsonb NOT NULL DEFAULT '{}'::JSONB,
  CONSTRAINT elements_id_pk PRIMARY KEY (id)
);

/* Indexes */
CREATE UNIQUE INDEX pages_xyid_unique_idx ON webmaker.pages (project_id, x, y) WHERE (deleted_at IS NULL);
CREATE INDEX user_idx_id_deleted_at ON webmaker.users (id, deleted_at);
CREATE INDEX project_deleted_at_user_id on webmaker.projects (deleted_at, user_id);
CREATE INDEX deleted_at_remixed_from_idx on webmaker.projects (deleted_at, remixed_from);
CREATE INDEX deleted_at_featured_idx on webmaker.projects (deleted_at, featured);
CREATE INDEX project_id_deleted_at_idx ON webmaker.pages (project_id, deleted_at);
CREATE INDEX deleted_at_page_id_idx ON webmaker.elements (deleted_at, page_id);
CREATE INDEX ON projects USING gin ((metadata -> 'tags'));

/* Triggers */
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_updated_at BEFORE UPDATE ON webmaker.users
FOR EACH ROW EXECUTE PROCEDURE update_updated_at();

CREATE TRIGGER update_project_updated_at BEFORE UPDATE ON webmaker.projects
FOR EACH ROW EXECUTE PROCEDURE update_updated_at();

CREATE TRIGGER update_page_updated_at BEFORE UPDATE ON webmaker.pages
FOR EACH ROW EXECUTE PROCEDURE update_updated_at();

CREATE TRIGGER update_element_updated_at BEFORE UPDATE ON webmaker.elements
FOR EACH ROW EXECUTE PROCEDURE update_updated_at();
