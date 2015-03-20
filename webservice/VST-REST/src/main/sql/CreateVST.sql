
SET client_encoding = 'UTF8';

DROP DATABASE IF EXISTS "VowelSpaceTravel"

CREATE DATABASE "VowelSpaceTravel" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';

\connect "VowelSpaceTravel"

SET client_encoding = 'UTF8';

SET default_with_oids = false;

SET TIME ZONE LOCAL;

CREATE TABLE vowel (
    vowel_id SERIAL UNIQUE NOT NULL,
    ipa text UNIQUE NOT NULL
);

CREATE TABLE speaker (
    speaker_id SERIAL UNIQUE NOT NULL,
    speaker_name text
);

CREATE TABLE word_sample (
    word_sample_id SERIAL UNIQUE NOT NULL,
    speaker_id text UNIQUE NOT NULL,
    vowel_id text UNIQUE NOT NULL,
    word_label text,
    sound_file text
);

CREATE TABLE vst_user (
    user_id SERIAL UNIQUE NOT NULL,
    last_modified timestamp default (current_timestamp AT TIME ZONE 'UTC'),
    user_name text
);