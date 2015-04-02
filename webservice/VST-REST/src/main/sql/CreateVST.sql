
SET client_encoding = 'UTF8';

DROP DATABASE IF EXISTS "VowelSpaceTravel";

CREATE DATABASE "VowelSpaceTravel" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';

\connect "VowelSpaceTravel"

SET client_encoding = 'UTF8';

SET default_with_oids = false;

SET TIME ZONE LOCAL;

-- vowel and word tables 

CREATE TABLE vowel_place (
    place text UNIQUE NOT NULL,
    PRIMARY KEY(place)
);

CREATE TABLE vowel_roundness (
    roundness text UNIQUE NOT NULL,
    PRIMARY KEY(roundness)
);

CREATE TABLE vowel_manner (
    manner text UNIQUE NOT NULL,
    PRIMARY KEY(manner)
);

CREATE TABLE vowels (
    vowel_id SERIAL UNIQUE NOT NULL,
    ipa text  NOT NULL,
    disc text UNIQUE NOT NULL,
    place text REFERENCES vowel_place(place) NOT NULL,
    manner text REFERENCES vowel_manner(manner) NOT NULL,
    roundness text REFERENCES vowel_roundness(roundness) NOT NULL
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
'near-front',
'near-close',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('ɛ', 'E', 
'front',
'open-mid',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('æ', '{', 
'front',
'near-open',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('ʌ', 'V', 
'back',
'open-mid',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('ɒ', 'Q', 
'back',
'open',
'rounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('ʊ', 'U', 
'near-back',
'near-close',
'rounded'
);

-- ə	@	another
		
-- eɪ	1	bay
-- aɪ	2	buy
-- ɔɪ	4	boy
-- əʊ	5	no
-- aʊ	6	brow
-- ɪə	7	peer
-- ɛə	8	pair
-- ʊə	9	poor
INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('iː', 'i', 
'front',
'close',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('ɑː', '#', 
'back',
'open',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('ɔː', '$', 
'back',
'open-mid',
'rounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('uː', 'u', 
'back',
'close',
'rounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('ɜː', '3', 
'central',
'open-mid',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '1', 
'near-front',
'near-close',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '2', 
'near-front',
'near-close',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '4', 
'near-front',
'near-close',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '5', 
'near-back',
'near-close',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '6', 
'near-back',
'near-close',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '1', 
'front',
'close-mid',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '2', 
'front',
'open',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '4', 
'back',
'open-mid',
'rounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '5', 
'central',
'mid',
'unrounded'
);

INSERT INTO vowels(ipa, disc, place, manner, roundness) VALUES ('', '6', 
'front',
'open',
'unrounded'
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



-- IPA	DISC	Ex.
-- p	p	pat
-- b	b	bad
-- t 	t	tack
-- d	d	dad
-- k	k	cad
-- g	g	game
-- ŋ	N	bang
-- m	m	mad
-- n	n	nat
-- l	l	lad
-- r	r	rat
-- f	f	fat
-- v	v	vat
-- θ	T	thin
-- ð	D	then
-- s	s	sap
-- z	z	zap
-- ʃ	S	sheep
-- ʒ	Z	measure
-- j	j	yank
-- x	x	loch
-- h	h	had
-- w	w	why
-- 		
-- tʃ	J	cheap
-- dʒ	_	jeep
-- 		
-- ŋ̩	C	bacon
-- m̩	F	idealism
-- n̩	H	burden
-- l̩	P	dangle
-- 		
-- *	R	father
-- 

-- todo: 
-- add table languages 
-- add join table languages of user