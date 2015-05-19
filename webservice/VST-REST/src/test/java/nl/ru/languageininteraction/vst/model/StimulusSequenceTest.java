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
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * @since May 19, 2015 3:01:11 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class StimulusSequenceTest {

    public StimulusSequenceTest() {
    }

    /**
     * Test of getRandomWords method, of class StimulusSequence.
     * discrimination takes input of a vowel pair (because the selection of this vowel pair is yet to be defined)
     * task type: 
     *  discrimination {sequence of samples with a single target vowel and single standard vowel} a, a, a, e, a, e, e 
     *  identification {sequence of samples each with a single target vowel and multiple distinct standard vowels} a, e, a, u, a, i
     * difficulty level
     * number of speakers in stimuli selection
     * requireSameStartingConsonent
     */
    @Test
    public void testGetRandomWords() {
        System.out.println("getRandomWords");
        StimulusSequence instance = null;
        ArrayList<Stimulus> expResult = null;
        ArrayList<Stimulus> result = instance.getRandomWords();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
}