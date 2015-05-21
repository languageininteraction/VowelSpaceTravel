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

import java.util.ArrayList;
import java.util.HashSet;
import nl.ru.languageininteraction.vst.Application;
import nl.ru.languageininteraction.vst.rest.WordSampleRepository;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @since May 19, 2015 3:01:11 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {Application.class})
public class StimulusSequenceTest {

    @Autowired
    WordSampleRepository wordSampleRepository;

    public StimulusSequenceTest() {
    }

    @Before
    public void insertData() {
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
        wordSampleRepository.save(new WordSample());
    }

    /**
     * Test of getRandomWords method, of class StimulusSequence.
     */
    @Test
    public void testGetRandomWords() {
        System.out.println("getRandomWords");
        final StimulusSequence stimulusSequence = new StimulusSequence(wordSampleRepository, new Player());
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
        int maxSize = 0;
        StimulusSequence instance = null;
        ArrayList<Stimulus> expResult = null;
//        ArrayList<Stimulus> result = instance.getDiscriminationWords(maxSize);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
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
//        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
}
