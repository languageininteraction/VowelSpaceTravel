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

import nl.ru.languageininteraction.vst.Application;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.SettingsRepository;
import nl.ru.languageininteraction.vst.rest.SpeakerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;
import nl.ru.languageininteraction.vst.util.AudioSamplesIngester;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @since May 18, 2015 5:54:30 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {Application.class})
public class ConfidenceTest {

    @Autowired
    private VowelRepository vowelRepository;
    @Autowired
    private PlayerRepository playerRepository;
    @Autowired
    private StimulusResponseRepository stimulusResultRepository;
    @Autowired
    private WordRepository wordsRepository;
    @Autowired
    private SpeakerRepository speakerRepository;
    @Autowired
    private ConsonantRepository consonantRepository;
    @Autowired
    private SettingsRepository settingsRepository;
    @Autowired
    private AudioSamplesIngester audioSamplesIngester;

    final Vowel targetVowel = new Vowel();
    final Vowel standardVowel = new Vowel();
    final Player player = new Player("a", "b", "c", 1, null);

    public ConfidenceTest() {
    }

    private void insertTestData(final int truePositiveCount, final int falsePositiveCount, final int trueNegativeCount, final int falseNegativeCount) {
        playerRepository.save(player);
        vowelRepository.save(targetVowel);
        vowelRepository.save(standardVowel);
        stimulusResultRepository.deleteAll();
        for (int truePositiveCounter = 0; truePositiveCounter < truePositiveCount; truePositiveCounter++) {
            stimulusResultRepository.save(new StimulusResponse(player, targetVowel, standardVowel, true, true, 1));
        }
        for (int falsePositiveCounter = 0; falsePositiveCounter < falsePositiveCount; falsePositiveCounter++) {
            stimulusResultRepository.save(new StimulusResponse(player, targetVowel, standardVowel, false, true, 1));
        }
        for (int trueNegativeCounter = 0; trueNegativeCounter < trueNegativeCount; trueNegativeCounter++) {
            stimulusResultRepository.save(new StimulusResponse(player, targetVowel, standardVowel, false, false, 1));
        }
        for (int falseNegativeCounter = 0; falseNegativeCounter < falseNegativeCount; falseNegativeCounter++) {
            stimulusResultRepository.save(new StimulusResponse(player, targetVowel, standardVowel, true, false, 1));
        }
    }

    /**
     * Test of getLowerBound via the CRUD DB with inserted user results.
     */
    @org.junit.Test
    public void testGetLowerBoundViaCrudDb() {
        System.out.println("testGetLowerBoundViaCrudDb");
        insertTestData(8, 8, 8, 8);
        assertEquals(0.3315, new Confidence(stimulusResultRepository, targetVowel, standardVowel).getLowerBound(), 0.01);
        insertTestData(0, 8, 8, 8);
        assertEquals(0.1797, new Confidence(stimulusResultRepository, targetVowel, standardVowel).getLowerBound(), 0.01);
    }

    /**
     * Test of getUpperBound via the CRUD DB with inserted user results.
     */
    @org.junit.Test
    public void testGetUpperBoundViaCrudDb() {
        System.out.println("testGetUpperBoundViaCrudDb");
        insertTestData(8, 8, 8, 8);
        assertEquals(0.66, new Confidence(stimulusResultRepository, targetVowel, standardVowel).getUpperBound(), 0.01);
        insertTestData(0, 8, 8, 8);
        assertEquals(0.5329, new Confidence(stimulusResultRepository, targetVowel, standardVowel).getUpperBound(), 0.01);
    }

    /**
     * Test of getLowerBound method, of class Confidence.
     */
    @Test
    public void testGetLowerBound() {
        System.out.println("getLowerBound");
        assertEquals(0.3315, new Confidence(8, 8, 8, 8).getLowerBound(), 0.01);
        assertEquals(0.1797, new Confidence(0, 8, 8, 8).getLowerBound(), 0.01);
    }

    /**
     * Test of getUpperBound method, of class Confidence.
     */
    @Test
    public void testGetUpperBound() {
        System.out.println("getUpperBound");
        assertEquals(0.66, new Confidence(8, 8, 8, 8).getUpperBound(), 0.01);
        assertEquals(0.5329, new Confidence(0, 8, 8, 8).getUpperBound(), 0.01);
    }
}
