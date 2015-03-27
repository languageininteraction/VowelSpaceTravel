
SET client_encoding = 'UTF8';

DROP DATABASE IF EXISTS "VowelSpaceTravel";

CREATE DATABASE "VowelSpaceTravel" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';

\connect "VowelSpaceTravel"

SET client_encoding = 'UTF8';

SET default_with_oids = false;

SET TIME ZONE LOCAL;

-- vowel and word tables 

CREATE TABLE vowel_place (
    id SERIAL UNIQUE NOT NULL,
    place text UNIQUE NOT NULL
);

CREATE TABLE vowel_roundness (
    id SERIAL UNIQUE NOT NULL,
    roundness text UNIQUE NOT NULL
);

CREATE TABLE vowel_manner (
    id SERIAL UNIQUE NOT NULL,
    manner text UNIQUE NOT NULL
);

CREATE TABLE vowels (
    vowel_id SERIAL UNIQUE NOT NULL,
    ipa text UNIQUE NOT NULL,
    disc text UNIQUE NOT NULL,
    place integer REFERENCES vowel_place(id) NOT NULL,
    manner integer REFERENCES vowel_manner(id) NOT NULL,
    roundness integer REFERENCES vowel_roundness(id) NOT NULL
);

INSERT INTO vowel_roundness(roundness) VALUES ('unrounded');
INSERT INTO vowel_roundness(roundness) VALUES ('rounded');
	
INSERT INTO vowel_place(place) VALUES ('front');
INSERT INTO vowel_place(place) VALUES ('near-front');
INSERT INTO vowel_place(place) VALUES ('central');
INSERT INTO vowel_place(place) VALUES ('near-back');
INSERT INTO vowel_place(place) VALUES ('back');

INSERT INTO vowel_manner(manner) VALUES ('close');
INSERT INTO vowel_manner(manner) VALUES ('near-close');
INSERT INTO vowel_manner(manner) VALUES ('close-mid');
INSERT INTO vowel_manner(manner) VALUES ('mid');
INSERT INTO vowel_manner(manner) VALUES ('open-mid');
INSERT INTO vowel_manner(manner) VALUES ('near-open');
INSERT INTO vowel_manner(manner) VALUES ('open');

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('I', 'I', 
(select id from vowel_place where (place = 'near-front')),
(select id from vowel_manner where (manner = 'near-close')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', 'E', 
(select id from vowel_place where (place = 'front')),
(select id from vowel_manner where (manner = 'open-mid')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '{', 
(select id from vowel_place where (place = 'front')),
(select id from vowel_manner where (manner = 'near-open')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', 'V', 
(select id from vowel_place where (place = 'back')),
(select id from vowel_manner where (manner = 'open-mid')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', 'Q', 
(select id from vowel_place where (place = 'back')),
(select id from vowel_manner where (manner = 'open')),
(select id from vowel_roundness where (roundness = 'rounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', 'U', 
(select id from vowel_place where (place = 'near-back')),
(select id from vowel_manner where (manner = 'near-close')),
(select id from vowel_roundness where (roundness = 'rounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', 'i', 
(select id from vowel_place where (place = 'front')),
(select id from vowel_manner where (manner = 'close')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '#', 
(select id from vowel_place where (place = 'back')),
(select id from vowel_manner where (manner = 'open')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '$', 
(select id from vowel_place where (place = 'back')),
(select id from vowel_manner where (manner = 'open-mid')),
(select id from vowel_roundness where (roundness = 'rounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', 'u', 
(select id from vowel_place where (place = 'back')),
(select id from vowel_manner where (manner = 'close')),
(select id from vowel_roundness where (roundness = 'rounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '3', 
(select id from vowel_place where (place = 'central')),
(select id from vowel_manner where (manner = 'open-mid')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '1', 
(select id from vowel_place where (place = 'near-front')),
(select id from vowel_manner where (manner = 'near-close')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '2', 
(select id from vowel_place where (place = 'near-front')),
(select id from vowel_manner where (manner = 'near-close')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '4', 
(select id from vowel_place where (place = 'near-front')),
(select id from vowel_manner where (manner = 'near-close')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '5', 
(select id from vowel_place where (place = 'near-back')),
(select id from vowel_manner where (manner = 'near-close')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '6', 
(select id from vowel_place where (place = 'near-back')),
(select id from vowel_manner where (manner = 'near-close')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '1', 
(select id from vowel_place where (place = 'front')),
(select id from vowel_manner where (manner = 'close-mid')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '2', 
(select id from vowel_place where (place = 'front')),
(select id from vowel_manner where (manner = 'open')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '4', 
(select id from vowel_place where (place = 'back')),
(select id from vowel_manner where (manner = 'open-mid')),
(select id from vowel_roundness where (roundness = 'rounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '5', 
(select id from vowel_place where (place = 'central')),
(select id from vowel_manner where (manner = 'mid')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '6', 
(select id from vowel_place where (place = 'front')),
(select id from vowel_manner where (manner = 'open')),
(select id from vowel_roundness where (roundness = 'unrounded'))
);


-- user tables 

CREATE TABLE speaker (
    speaker_id SERIAL UNIQUE NOT NULL,
    speaker_name text
);

CREATE TABLE word_sample (
    word_sample_id SERIAL UNIQUE NOT NULL,
    speaker_id integer REFERENCES speaker(speaker_id) NOT NULL,
    vowel_id integer REFERENCES vowel(vowel_id) NOT NULL,
    word_label text,
    sound_file text
);

CREATE TABLE vst_user (
    user_id SERIAL UNIQUE NOT NULL,
    last_modified timestamp default (current_timestamp AT TIME ZONE 'UTC'),
    user_name text
);



-- todo: 
-- add table languages 
-- add join table languages of user