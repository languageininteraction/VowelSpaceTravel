/*
 * Copyright (C) 2015 Language In Interaction
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package nl.ru.languageininteraction.vst.util;

import nl.ru.languageininteraction.vst.model.Consonant;
import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.model.VowelQuality;
import nl.ru.languageininteraction.vst.model.VowelQuality.Manner;
import nl.ru.languageininteraction.vst.model.VowelQuality.Place;
import nl.ru.languageininteraction.vst.model.VowelQuality.Roundness;
import nl.ru.languageininteraction.vst.model.Word;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelQualityRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;

/**
 * @since Apr 20, 2015 11:35:57 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class DefaultData {

    private final VowelRepository vowelRepository;
    private final VowelQualityRepository vowelQualityRepository;
    private final PlayerRepository playerRepository;
    private final StimulusResponseRepository stimulusResultRepository;
    private final WordRepository wordsRepository;
    private final ConsonantRepository consonantRepository;

    public DefaultData(VowelRepository vowelRepository, VowelQualityRepository vowelQualityRepository, PlayerRepository playerRepository, StimulusResponseRepository stimulusResultRepository, WordRepository wordsRepository, ConsonantRepository consonantRepository) {
        this.vowelRepository = vowelRepository;
        this.vowelQualityRepository = vowelQualityRepository;
        this.playerRepository = playerRepository;
        this.stimulusResultRepository = stimulusResultRepository;
        this.wordsRepository = wordsRepository;
        this.consonantRepository = consonantRepository;
    }

    private Consonant getConsonant(String consonantString) {
        Consonant consonant = consonantRepository.findByDisc(consonantString);
        if (consonant == null) {
            consonantRepository.save(new Consonant(null, consonantString));
            consonant = consonantRepository.findByDisc(consonantString);
        }
        return consonant;
    }

    private void insertWord(String wordString, String consonantString1, String vowelString, String consonantString2) {
        final Consonant consonant1 = getConsonant(consonantString1);
        final Consonant consonant2 = getConsonant(consonantString2);
        wordsRepository.save(new Word(wordString, consonant1, vowelRepository.findByDisc(vowelString), consonant2));
    }

    public void insertWords() {
        insertWord("babe", "b", "1", "b");
        insertWord("back", "b", "{", "k");
        insertWord("badge", "b", "{", "_");
        insertWord("bag", "b", "{", "g");
        insertWord("ball", "b", "$", "l");
        insertWord("barn", "b", "#", "n");
        insertWord("base", "b", "1", "s");
        insertWord("bath", "b", "#", "T");
        insertWord("beach", "b", "i", "J");
        insertWord("bed", "b", "E", "d");
        insertWord("beige", "b", "1", "Z");
        insertWord("berg", "b", "3", "g");
        insertWord("big", "b", "I", "g");
        insertWord("birth", "b", "3", "T");
        insertWord("bit", "b", "I", "t");
        insertWord("bite", "b", "2", "t");
        insertWord("board", "b", "$", "d");
        insertWord("boil", "b", "4", "l");
        insertWord("bomb", "b", "Q", "m");
        insertWord("book", "b", "U", "k");
        insertWord("boon", "b", "u", "n");
        insertWord("booth", "b", "u", "D");
        insertWord("both", "b", "5", "T");
        insertWord("bout", "b", "6", "t");
        insertWord("bush", "b", "U", "S");
        insertWord("but", "b", "V", "t");
        insertWord("butch", "b", "U", "J");
        insertWord("buzz", "b", "V", "z");
        insertWord("cab", "k", "{", "b");
        insertWord("can", "k", "{", "n");
        insertWord("card", "k", "#", "d");
        insertWord("carve", "k", "#", "v");
        insertWord("case", "k", "1", "s");
        insertWord("chain", "J", "1", "n");
        insertWord("chalk", "J", "$", "k");
        insertWord("chap", "J", "{", "p");
        insertWord("charge", "J", "#", "_");
        insertWord("cheque", "J", "E", "k");
        insertWord("chief", "J", "i", "f");
        insertWord("chime", "J", "2", "m");
        insertWord("chin", "J", "I", "n");
        insertWord("choice", "J", "4", "s");
        insertWord("choke", "J", "5", "k");
        insertWord("choose", "J", "u", "z");
        insertWord("chop", "J", "Q", "p");
        insertWord("chum", "J", "V", "m");
        insertWord("church", "J", "3", "J");
        insertWord("coach", "k", "5", "J");
        insertWord("coat", "k", "5", "t");
        insertWord("coin", "k", "4", "n");
        insertWord("come", "k", "V", "m");
        insertWord("cook", "k", "U", "k");
        insertWord("cool", "k", "u", "l");
        insertWord("cot", "k", "Q", "t");
        insertWord("couch", "k", "6", "J");
        insertWord("cough", "k", "Q", "f");
        insertWord("course", "k", "$", "s");
        insertWord("cup", "k", "V", "p");
        insertWord("curve", "k", "3", "v");
        insertWord("damn", "d", "{", "m");
        insertWord("dark", "d", "#", "k");
        insertWord("dawn", "d", "$", "n");
        insertWord("days", "d", "1", "z");
        insertWord("deaf", "d", "E", "f");
        insertWord("deal", "d", "i", "l");
        insertWord("death", "d", "E", "T");
        insertWord("dime", "d", "2", "m");
        insertWord("dirt", "d", "3", "t");
        insertWord("dish", "d", "I", "S");
        insertWord("dog", "d", "Q", "g");
        insertWord("dome", "d", "5", "m");
        insertWord("doom", "d", "u", "m");
        insertWord("dose", "d", "5", "s");
        insertWord("down", "d", "6", "n");
        insertWord("dull", "d", "V", "l");
        insertWord("face", "f", "1", "s");
        insertWord("faith", "f", "1", "T");
        insertWord("farm", "f", "#", "m");
        insertWord("fat", "f", "{", "t");
        insertWord("feel", "f", "i", "l");
        insertWord("fetch", "f", "E", "J");
        insertWord("firm", "f", "3", "m");
        insertWord("fish", "f", "I", "S");
        insertWord("five", "f", "2", "v");
        insertWord("fog", "f", "Q", "g");
        insertWord("foil", "f", "4", "l");
        insertWord("food", "f", "u", "d");
        insertWord("form", "f", "$", "m");
        insertWord("foul", "f", "6", "l");
        insertWord("full", "f", "U", "l");
        insertWord("fun", "f", "V", "n");
        insertWord("gaff", "g", "{", "f");
        insertWord("game", "g", "1", "m");
        insertWord("gas", "g", "{", "s");
        insertWord("gauche", "g", "5", "S");
        insertWord("get", "g", "E", "t");
        insertWord("gibe", "_", "2", "b");
        insertWord("gin", "_", "I", "n");
        insertWord("girl", "g", "3", "l");
        insertWord("give", "g", "I", "v");
        insertWord("goal", "g", "5", "l");
        insertWord("gone", "g", "Q", "n");
        insertWord("good", "g", "U", "d");
        insertWord("goose", "g", "u", "s");
        insertWord("gorge", "g", "$", "_");
        insertWord("gown", "g", "6", "n");
        insertWord("guard", "g", "#", "d");
        insertWord("guide", "g", "2", "d");
        insertWord("gun", "g", "V", "n");
        insertWord("half", "h", "#", "f");
        insertWord("hall", "h", "$", "l");
        insertWord("harsh", "h", "#", "S");
        insertWord("hate", "h", "1", "t");
        insertWord("have", "h", "{", "v");
        insertWord("head", "h", "E", "d");
        insertWord("heat", "h", "i", "t");
        insertWord("heath", "h", "i", "T");
        insertWord("hedge", "h", "E", "_");
        insertWord("height", "h", "2", "t");
        insertWord("hers", "h", "3", "z");
        insertWord("his", "h", "I", "z");
        insertWord("home", "h", "5", "m");
        insertWord("hook", "h", "U", "k");
        insertWord("hope", "h", "5", "p");
        insertWord("hot", "h", "Q", "t");
        insertWord("house", "h", "6", "s");
        insertWord("hut", "h", "V", "t");
        insertWord("jail", "_", "1", "l");
        insertWord("jam", "_", "{", "m");
        insertWord("jazz", "_", "{", "z");
        insertWord("jeep", "_", "i", "p");
        insertWord("jerk", "_", "3", "k");
        insertWord("jet", "_", "E", "t");
        insertWord("job", "_", "Q", "b");
        insertWord("join", "_", "4", "n");
        insertWord("joke", "_", "5", "k");
        insertWord("jowl", "_", "6", "l");
        insertWord("judge", "_", "V", "_");
        insertWord("juice", "_", "u", "s");
        insertWord("keep", "k", "i", "p");
        insertWord("keg", "k", "E", "g");
        insertWord("kerb", "k", "3", "b");
        insertWord("kid", "k", "I", "d");
        insertWord("king", "k", "I", "N");
        insertWord("kite", "k", "2", "t");
        insertWord("known", "n", "5", "n");
        insertWord("lack", "l", "{", "k");
        insertWord("large", "l", "#", "_");
        insertWord("late", "l", "1", "t");
        insertWord("lathe", "l", "1", "D");
        insertWord("lawn", "l", "$", "n");
        insertWord("league", "l", "i", "g");
        insertWord("learn", "l", "3", "n");
        insertWord("leash", "l", "i", "S");
        insertWord("leave", "l", "i", "v");
        insertWord("less", "l", "E", "s");
        insertWord("lib", "l", "I", "b");
        insertWord("life", "l", "2", "f");
        insertWord("like", "l", "2", "k");
        insertWord("lithe", "l", "2", "D");
        insertWord("live", "l", "I", "v");
        insertWord("loaf", "l", "5", "f");
        insertWord("loan", "l", "5", "n");
        insertWord("lodge", "l", "Q", "_");
        insertWord("loin", "l", "4", "n");
        insertWord("long", "l", "Q", "N");
        insertWord("look", "l", "U", "k");
        insertWord("loose", "l", "u", "s");
        insertWord("loss", "l", "Q", "s");
        insertWord("loud", "l", "6", "d");
        insertWord("love", "l", "V", "v");
        insertWord("luck", "l", "V", "k");
        insertWord("make", "m", "1", "k");
        insertWord("mall", "m", "$", "l");
        insertWord("man", "m", "{", "n");
        insertWord("march", "m", "#", "J");
        insertWord("mark", "m", "#", "k");
        insertWord("math", "m", "{", "T");
        insertWord("mauve", "m", "5", "v");
        insertWord("meet", "m", "i", "t");
        insertWord("mesh", "m", "E", "S");
        insertWord("mess", "m", "E", "s");
        insertWord("mine", "m", "2", "n");
        insertWord("mirth", "m", "3", "T");
        insertWord("mob", "m", "Q", "b");
        insertWord("mode", "m", "5", "d");
        insertWord("morgue", "m", "$", "g");
        insertWord("mouth", "m", "6", "T");
        insertWord("move", "m", "u", "v");
        insertWord("much", "m", "V", "J");
        insertWord("mud", "m", "V", "d");
        insertWord("myth", "m", "I", "T");
        insertWord("name", "n", "1", "m");
        insertWord("nap", "n", "{", "p");
        insertWord("neck", "n", "E", "k");
        insertWord("need", "n", "i", "d");
        insertWord("niche", "n", "I", "J");
        insertWord("night", "n", "2", "t");
        insertWord("noise", "n", "4", "z");
        insertWord("none", "n", "V", "n");
        insertWord("nook", "n", "U", "k");
        insertWord("noon", "n", "u", "n");
        insertWord("north", "n", "$", "T");
        insertWord("not", "n", "Q", "t");
        insertWord("nous", "n", "6", "s");
        insertWord("nurse", "n", "3", "s");
        insertWord("one", "w", "V", "n");
        insertWord("page", "p", "1", "_");
        insertWord("pain", "p", "1", "n");
        insertWord("pan", "p", "{", "n");
        insertWord("part", "p", "#", "t");
        insertWord("pass", "p", "#", "s");
        insertWord("pen", "p", "E", "n");
        insertWord("phone", "f", "5", "n");
        insertWord("piece", "p", "i", "s");
        insertWord("pile", "p", "2", "l");
        insertWord("pitch", "p", "I", "J");
        insertWord("poise", "p", "4", "z");
        insertWord("pole", "p", "5", "l");
        insertWord("pool", "p", "u", "l");
        insertWord("porch", "p", "$", "J");
        insertWord("port", "p", "$", "t");
        insertWord("pot", "p", "Q", "t");
        insertWord("pouch", "p", "6", "J");
        insertWord("pub", "p", "V", "b");
        insertWord("purse", "p", "3", "s");
        insertWord("puss", "p", "U", "s");
        insertWord("put", "p", "U", "t");
        insertWord("raj", "r", "#", "_");
        insertWord("rash", "r", "{", "S");
        insertWord("rate", "r", "1", "t");
        insertWord("read", "r", "i", "d");
        insertWord("red", "r", "E", "d");
        insertWord("rep", "r", "E", "p");
        insertWord("rich", "r", "I", "J");
        insertWord("ridge", "r", "I", "_");
        insertWord("right", "r", "2", "t");
        insertWord("road", "r", "5", "d");
        insertWord("robe", "r", "5", "b");
        insertWord("rock", "r", "Q", "k");
        insertWord("rod", "r", "Q", "d");
        insertWord("roof", "r", "u", "f");
        insertWord("room", "r", "u", "m");
        insertWord("rouge", "r", "u", "Z");
        insertWord("rough", "r", "V", "f");
        insertWord("rouse", "r", "6", "z");
        insertWord("rout", "r", "6", "t");
        insertWord("rug", "r", "V", "g");
        insertWord("run", "r", "V", "n");
        insertWord("rush", "r", "V", "S");
        insertWord("sad", "s", "{", "d");
        insertWord("safe", "s", "1", "f");
        insertWord("sahib", "s", "#", "b");
        insertWord("same", "s", "1", "m");
        insertWord("scene", "s", "i", "n");
        insertWord("search", "s", "3", "J");
        insertWord("set", "s", "E", "t");
        insertWord("shade", "S", "1", "d");
        insertWord("shall", "S", "{", "l");
        insertWord("shape", "S", "1", "p");
        insertWord("sharp", "S", "#", "p");
        insertWord("sheet", "S", "i", "t");
        insertWord("shell", "S", "E", "l");
        insertWord("shine", "S", "2", "n");
        insertWord("ship", "S", "I", "p");
        insertWord("shirt", "S", "3", "t");
        insertWord("shoal", "S", "5", "l");
        insertWord("shoot", "S", "u", "t");
        insertWord("shop", "S", "Q", "p");
        insertWord("short", "S", "$", "t");
        insertWord("should", "S", "U", "d");
        insertWord("shout", "S", "6", "t");
        insertWord("shut", "S", "V", "t");
        insertWord("sick", "s", "I", "k");
        insertWord("side", "s", "2", "d");
        insertWord("siege", "s", "i", "_");
        insertWord("size", "s", "2", "z");
        insertWord("soil", "s", "4", "l");
        insertWord("some", "s", "V", "m");
        insertWord("song", "s", "Q", "N");
        insertWord("soon", "s", "u", "n");
        insertWord("soot", "s", "U", "t");
        insertWord("sort", "s", "$", "t");
        insertWord("soul", "s", "5", "l");
        insertWord("soup", "s", "u", "p");
        insertWord("south", "s", "6", "T");
        insertWord("surf", "s", "3", "f");
        insertWord("surge", "s", "3", "_");
        insertWord("take", "t", "1", "k");
        insertWord("talk", "t", "$", "k");
        insertWord("tap", "t", "{", "p");
        insertWord("tart", "t", "#", "t");
        insertWord("team", "t", "i", "m");
        insertWord("ten", "t", "E", "n");
        insertWord("that", "D", "{", "t");
        insertWord("thatch", "T", "{", "J");
        insertWord("them", "D", "E", "m");
        insertWord("theme", "T", "i", "m");
        insertWord("these", "D", "i", "z");
        insertWord("thine", "D", "2", "n");
        insertWord("thing", "T", "I", "N");
        insertWord("third", "T", "3", "d");
        insertWord("this", "D", "I", "s");
        insertWord("thong", "T", "Q", "N");
        insertWord("those", "D", "5", "z");
        insertWord("thought", "T", "$", "t");
        insertWord("thumb", "T", "V", "m");
        insertWord("thus", "D", "V", "s");
        insertWord("till", "t", "I", "l");
        insertWord("time", "t", "2", "m");
        insertWord("toil", "t", "4", "l");
        insertWord("tone", "t", "5", "n");
        insertWord("tool", "t", "u", "l");
        insertWord("top", "t", "Q", "p");
        insertWord("touch", "t", "V", "J");
        insertWord("town", "t", "6", "n");
        insertWord("turn", "t", "3", "n");
        insertWord("type", "t", "2", "p");
        insertWord("use", "j", "u", "s");
        insertWord("vague", "v", "1", "g");
        insertWord("van", "v", "{", "n");
        insertWord("vase", "v", "#", "z");
        insertWord("veal", "v", "i", "l");
        insertWord("verse", "v", "3", "s");
        insertWord("vet", "v", "E", "t");
        insertWord("vice", "v", "2", "s");
        insertWord("vim", "v", "I", "m");
        insertWord("vogue", "v", "5", "g");
        insertWord("voice", "v", "4", "s");
        insertWord("void", "v", "4", "d");
        insertWord("vol", "v", "Q", "l");
        insertWord("vote", "v", "5", "t");
        insertWord("wack", "w", "{", "k");
        insertWord("wall", "w", "$", "l");
        insertWord("warp", "w", "$", "p");
        insertWord("wash", "w", "Q", "S");
        insertWord("watch", "w", "Q", "J");
        insertWord("wave", "w", "1", "v");
        insertWord("web", "w", "E", "b");
        insertWord("week", "w", "i", "k");
        insertWord("weight", "w", "1", "t");
        insertWord("wharf", "w", "$", "f");
        insertWord("what", "w", "Q", "t");
        insertWord("when", "w", "E", "n");
        insertWord("whiff", "w", "I", "f");
        insertWord("while", "w", "2", "l");
        insertWord("whose", "h", "u", "z");
        insertWord("with", "w", "I", "D");
        insertWord("womb", "w", "u", "m");
        insertWord("work", "w", "3", "k");
        insertWord("would", "w", "U", "d");
        insertWord("wrath", "r", "Q", "T");
        insertWord("wrong", "r", "Q", "N");
        insertWord("wrought", "r", "$", "t");
        insertWord("yacht", "j", "Q", "t");
        insertWord("yang", "j", "{", "N");
        insertWord("yard", "j", "#", "d");
        insertWord("yes", "j", "E", "s");
        insertWord("yin", "j", "I", "n");
        insertWord("yolk", "j", "5", "k");
        insertWord("young", "j", "V", "N");
        insertWord("yours", "j", "$", "z");
        insertWord("youth", "j", "u", "T");
        insertWord("zeal", "z", "i", "l");
        insertWord("zed", "z", "E", "d");
        insertWord("zip", "z", "I", "p");
        insertWord("zone", "z", "5", "n");
    }

    public void insertConsonants() {
        // consonants are added by the words insert
    }

    private void addOrUpdateVowel(String ipa, String disc, Place place, Manner manner, Roundness roundness) {
        Vowel vowel = vowelRepository.findByDisc(disc);
        if (vowel == null) {
            vowel = new Vowel(ipa, disc);
            vowelRepository.save(vowel);
        }
        final VowelQuality vowelQuality = new VowelQuality(vowel, place, manner, roundness);
        vowelQualityRepository.save(vowelQuality);
    }

    public void insertVowels() {
        addOrUpdateVowel("I", "I", VowelQuality.Place.near_front, VowelQuality.Manner.near_close, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("E", "E", VowelQuality.Place.front, VowelQuality.Manner.open_mid, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("{", "{", VowelQuality.Place.front, VowelQuality.Manner.near_open, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("V", "V", VowelQuality.Place.back, VowelQuality.Manner.open_mid, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("Q", "Q", VowelQuality.Place.back, VowelQuality.Manner.open, VowelQuality.Roundness.rounded);
        addOrUpdateVowel("U", "U", VowelQuality.Place.near_back, VowelQuality.Manner.near_close, VowelQuality.Roundness.rounded);
        addOrUpdateVowel("i", "i", VowelQuality.Place.front, VowelQuality.Manner.close, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("#", "#", VowelQuality.Place.back, VowelQuality.Manner.open, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("$", "$", VowelQuality.Place.back, VowelQuality.Manner.open_mid, VowelQuality.Roundness.rounded);
        addOrUpdateVowel("u", "u", VowelQuality.Place.back, VowelQuality.Manner.close, VowelQuality.Roundness.rounded);
        addOrUpdateVowel("3", "3", VowelQuality.Place.central, VowelQuality.Manner.open_mid, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("1", "1", VowelQuality.Place.near_front, VowelQuality.Manner.near_close, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("2", "2", VowelQuality.Place.near_front, VowelQuality.Manner.near_close, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("4", "4", VowelQuality.Place.near_front, VowelQuality.Manner.near_close, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("5", "5", VowelQuality.Place.near_back, VowelQuality.Manner.near_close, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("6", "6", VowelQuality.Place.near_back, VowelQuality.Manner.near_close, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("1", "1", VowelQuality.Place.front, VowelQuality.Manner.close_mid, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("2", "2", VowelQuality.Place.front, VowelQuality.Manner.open, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("4", "4", VowelQuality.Place.back, VowelQuality.Manner.open_mid, VowelQuality.Roundness.rounded);
        addOrUpdateVowel("5", "5", VowelQuality.Place.central, VowelQuality.Manner.mid, VowelQuality.Roundness.unrounded);
        addOrUpdateVowel("6", "6", VowelQuality.Place.front, VowelQuality.Manner.open, VowelQuality.Roundness.unrounded);
    }
}
