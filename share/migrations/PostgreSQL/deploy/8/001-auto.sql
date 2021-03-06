-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sat Jan 25 17:55:12 2020
-- 
;
--
-- Table: group
--
CREATE TABLE "group" (
  "id" serial NOT NULL,
  "name" character varying(50) NOT NULL,
  PRIMARY KEY ("id")
);

;
--
-- Table: user
--
CREATE TABLE "user" (
  "id" serial NOT NULL,
  "firstname" text,
  "surname" text,
  "email" character varying(128) NOT NULL,
  "username" character varying(128) NOT NULL,
  "password" character varying(128),
  "pwchanged" timestamp,
  "pw_reset_code" character(32),
  "lastlogin" timestamp,
  "notify_all_ssh" smallint DEFAULT 0 NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "user_idx_email" on "user" ("email");
CREATE INDEX "user_idx_username" on "user" ("username");

;
--
-- Table: fingerprint
--
CREATE TABLE "fingerprint" (
  "id" serial NOT NULL,
  "user_id" integer NOT NULL,
  "fingerprint" character varying(64) NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "fingerprint_idx_user_id" on "fingerprint" ("user_id");

;
--
-- Table: host
--
CREATE TABLE "host" (
  "id" serial NOT NULL,
  "name" character varying(50) NOT NULL,
  "port" integer,
  "password" character varying(64),
  "group_id" integer,
  PRIMARY KEY ("id")
);
CREATE INDEX "host_idx_group_id" on "host" ("group_id");

;
--
-- Table: host_checker
--
CREATE TABLE "host_checker" (
  "id" serial NOT NULL,
  "name" character varying(50) NOT NULL,
  "host" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "host_checker_idx_host" on "host_checker" ("host");

;
--
-- Table: statval
--
CREATE TABLE "statval" (
  "id" serial NOT NULL,
  "datetime" timestamp NOT NULL,
  "stattype" character varying(50) NOT NULL,
  "host" integer DEFAULT 0 NOT NULL,
  "plugin" character varying(50) NOT NULL,
  "decimal" numeric(10,3),
  "param" character varying(50),
  "failcount" integer,
  "string" text,
  PRIMARY KEY ("id")
);
CREATE INDEX "statval_idx_host" on "statval" ("host");
CREATE INDEX "statval_idx_datetime" on "statval" ("datetime");
CREATE INDEX "statval_idx_host_datetime" on "statval" ("host", "datetime");

;
--
-- Table: user_group
--
CREATE TABLE "user_group" (
  "id" serial NOT NULL,
  "user_id" integer NOT NULL,
  "group_id" integer NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "user_group_idx_group_id" on "user_group" ("group_id");
CREATE INDEX "user_group_idx_user_id" on "user_group" ("user_id");

;
--
-- Table: sshlogin
--
CREATE TABLE "sshlogin" (
  "id" serial NOT NULL,
  "host_id" integer NOT NULL,
  "user_id" integer,
  "username" character varying(50) NOT NULL,
  "source_ip" character varying(50) NOT NULL,
  "datetime" timestamp NOT NULL,
  "fingerprint" character varying(64) NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "sshlogin_idx_host_id" on "sshlogin" ("host_id");
CREATE INDEX "sshlogin_idx_user_id" on "sshlogin" ("user_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "fingerprint" ADD CONSTRAINT "fingerprint_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "user" ("id") DEFERRABLE;

;
ALTER TABLE "host" ADD CONSTRAINT "host_fk_group_id" FOREIGN KEY ("group_id")
  REFERENCES "group" ("id") DEFERRABLE;

;
ALTER TABLE "host_checker" ADD CONSTRAINT "host_checker_fk_host" FOREIGN KEY ("host")
  REFERENCES "host" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "statval" ADD CONSTRAINT "statval_fk_host" FOREIGN KEY ("host")
  REFERENCES "host" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_group" ADD CONSTRAINT "user_group_fk_group_id" FOREIGN KEY ("group_id")
  REFERENCES "group" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_group" ADD CONSTRAINT "user_group_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "user" ("id") DEFERRABLE;

;
ALTER TABLE "sshlogin" ADD CONSTRAINT "sshlogin_fk_host_id" FOREIGN KEY ("host_id")
  REFERENCES "host" ("id") DEFERRABLE;

;
ALTER TABLE "sshlogin" ADD CONSTRAINT "sshlogin_fk_user_id" FOREIGN KEY ("user_id")
  REFERENCES "user" ("id") DEFERRABLE;

;
