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
package nl.ru.languageininteraction.vst.model;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import nl.ru.languageininteraction.vst.Application;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelQualityRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;
import nl.ru.languageininteraction.vst.rest.WordSampleRepository;
import nl.ru.languageininteraction.vst.util.AudioSamplesIngester;
import nl.ru.languageininteraction.vst.util.DefaultData;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @since May 19, 2015 3:01:11 PM (creation date)
 * @author Peter Withers {@literal <p.withers@psych.ru.nl>}
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {Application.class})
public class StimulusSequenceTest {

    @Autowired
    WordSampleRepository wordSampleRepository;
    @Autowired
    VowelRepository vowelRepository;
    @Autowired
    VowelQualityRepository vowelQualityRepository;
    @Autowired
    PlayerRepository playerRepository;
    @Autowired
    StimulusResponseRepository stimulusResultRepository;
    @Autowired
    WordRepository wordsRepository;
    @Autowired
    ConsonantRepository consonantRepository;
    @Autowired
    private AudioSamplesIngester audioSamplesIngester;

    public StimulusSequenceTest() {
    }

    @Before
    public void insertData() throws IOException {
        if (wordSampleRepository.count() == 0) {
            final DefaultData defaultData = new DefaultData(vowelRepository, vowelQualityRepository, playerRepository, stimulusResultRepository, wordsRepository, consonantRepository);
            defaultData.insertVowels();
            defaultData.insertConsonants();
            defaultData.insertWords();
            audioSamplesIngester.processAudioResources();
        }
    }

    /**
     * Test of getRandomWords method, of class StimulusSequence.
     */
    @Test
    public void testGetRandomWords() {
        System.out.println("getRandomWords");
        final StimulusSequence stimulusSequence = new StimulusSequence(wordSampleRepository, new Player(), vowelRepository);
        int expResultCount = 23;
        ArrayList<Stimulus> result1 = stimulusSequence.getRandomWords((int) wordSampleRepository.count() + expResultCount);
        assertEquals(wordSampleRepository.count(), result1.size());
        ArrayList<Stimulus> result2 = stimulusSequence.getRandomWords(expResultCount);
        assertEquals(expResultCount, result2.size());
        assertEquals(expResultCount, new HashSet<Stimulus>(result2).size());
    }

    /**
     * Test of getDiscriminationWords method, of class StimulusSequence. *
     * discrimination takes input of a vowel pair (because the selection of this
     * vowel pair is yet to be defined) task type: discrimination {sequence of
     * samples with a single target vowel and single standard vowel} a, a, a, e,
     * a, e, e identification {sequence of samples each with a single target
     * vowel and multiple distinct standard vowels} a, e, a, u, a, i difficulty
     * level number of speakers in stimuli selection
     * requireSameStartingConsonent
     *
     */
    @Test
    public void testGetDiscriminationWords() {
        System.out.println("getDiscriminationWords");
        final StimulusSequence stimulusSequence = new StimulusSequence(wordSampleRepository, new Player(), vowelRepository);
        int expResultCount = 23;
        int stimulusIndex = 0;
        boolean lastWasTarget = false;
        int targetCount = 0;
        int expTargetCount = 10;
        Vowel targetVowel = vowelRepository.findByDisc("U"/*(long) new Random().nextInt((int) vowelRepository.count())*/);
        Vowel standardVowel = vowelRepository.findByDisc("{"/*(long) new Random().nextInt((int) vowelRepository.count())*/);
        ArrayList<Stimulus> result1 = stimulusSequence.getDiscriminationWords((int) wordSampleRepository.count() + expResultCount, expTargetCount, targetVowel, standardVowel, Difficulty.veryhard);
        assertEquals(wordSampleRepository.count() + expResultCount, result1.size());
        // test that the first three words contain the target vowel
        // and that each subsequent pair of words sequentially contain the standard then target vowels

        for (Stimulus stimulus : result1) {
            if (stimulusIndex == 0) {
                assertEquals(targetVowel.getDisc(), stimulus.getWordSample().getWord().getVowel().getDisc());
            } else if (stimulusIndex < 4) {
                assertEquals(standardVowel.getDisc(), stimulus.getWordSample().getWord().getVowel().getDisc());
            } else {
                if (targetVowel.getDisc().equals(stimulus.getWordSample().getWord().getVowel().getDisc())) {
                    targetCount++;
                }
                if (lastWasTarget) {
                    // there cannot be two targets in a row
                    assertEquals(standardVowel.getDisc(), stimulus.getWordSample().getWord().getVowel().getDisc());
                }
                lastWasTarget = targetVowel.getDisc().equals(stimulus.getWordSample().getWord().getVowel().getDisc());
            }
            stimulusIndex++;
        }
        // todo: at times the target number can be too low and this should be addressed
        assertEquals(expTargetCount, targetCount);
//        ArrayList<Stimulus> result2 = stimulusSequence.getDiscriminationWords(expResultCount, targetVowel, standardVowel);
//        assertEquals(expResultCount, result2.size());
//        assertEquals(expResultCount, new HashSet<Stimulus>(result2).size());
    }

    @Test
    public void testGetDiscriminationWordsDifficulty() {
        System.out.println("getDiscriminationWords");
        final StimulusSequence stimulusSequence = new StimulusSequence(wordSampleRepository, new Player(), vowelRepository);
        Vowel targetVowel = vowelRepository.findByDisc("U"/*(long) new Random().nextInt((int) vowelRepository.count())*/);
        Vowel standardVowel = vowelRepository.findByDisc("{"/*(long) new Random().nextInt((int) vowelRepository.count())*/);
        int maxSize = 100;
        int maxTargetCount = 10;
        // pass each Difficulty when creating a sequence and check that the correct output is produced
        for (Difficulty difficulty : Difficulty.values()) {
            System.out.println(difficulty);
            ArrayList<Stimulus> result1 = stimulusSequence.getDiscriminationWords(maxSize, maxTargetCount, targetVowel, standardVowel, difficulty);
            assertEquals(maxSize, result1.size());
            HashSet<Speaker> speakers = new HashSet<>();
            HashSet<Consonant> consonants = new HashSet<>();
            for (Stimulus stimulus : result1) {
                System.out.println(stimulus.getWordSample().getSpokenBy().getLabel());
                System.out.println(stimulus.getWordSample().getWord().getInitailConsonant().getDisc());
                speakers.add(stimulus.getWordSample().getSpokenBy());
                consonants.add(stimulus.getWordSample().getWord().getInitailConsonant());
            }
            switch (difficulty) {
                case easy:
                    assertEquals(1, speakers.size());
                    assertEquals(1, consonants.size());
                    break;
                case medium:
                    assertFalse(1 == speakers.size());
                    assertEquals(1, consonants.size());
                    break;
                case hard:
                    assertEquals(1, speakers.size());
                    assertFalse(1 == consonants.size());
                    break;
                case veryhard:
                    assertFalse(1 == speakers.size());
                    assertFalse(1 == consonants.size());
                    break;
                default:
                    fail("Unexpected Difficulty level:" + difficulty);
            }
        }
    }

    /**
     * Test of getIdentificationWords method, of class StimulusSequence. *
     * discrimination takes input of a vowel pair (because the selection of this
     * vowel pair is yet to be defined) task type: discrimination {sequence of
     * samples with a single target vowel and single standard vowel} a, a, a, e,
     * a, e, e identification {sequence of samples each with a single target
     * vowel and multiple distinct standard vowels} a, e, a, u, a, i difficulty
     * level number of speakers in stimuli selection
     * requireSameStartingConsonent
     *
     */
    @Test
    public void testGetIdentificationWords() {
        System.out.println("getIdentificationWords");
        int maxSize = 0;
        StimulusSequence instance = null;
        ArrayList<Stimulus> expResult = null;
//        ArrayList<Stimulus> result = instance.getIdentificationWords(maxSize);
//        assertEquals(expResult, result);
//        // TODO: review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
    }
}
