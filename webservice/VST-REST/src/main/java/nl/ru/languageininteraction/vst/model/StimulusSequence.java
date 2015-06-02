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

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.ArrayList;
import java.util.List;
import java.util.PrimitiveIterator;
import java.util.Random;
import java.util.stream.IntStream;
import nl.ru.languageininteraction.vst.rest.WordSampleRepository;
import org.springframework.hateoas.ResourceSupport;

/**
 * @since Apr 16, 2015 1:57:15 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class StimulusSequence extends ResourceSupport {

    private final WordSampleRepository sampleRepository;
    private final Player player;

    @JsonCreator
    public StimulusSequence(WordSampleRepository sampleRepository, @JsonProperty("player") Player player) {
        // todo: prehaps the settings object could also be sent rather than using a previously stored values?
        this.sampleRepository = sampleRepository;
        this.player = player;
    }

    public ArrayList<Stimulus> getRandomWords(int maxSize) {
        final ArrayList<Stimulus> stimulusList = new ArrayList<>();
        final int availableCount = (maxSize < (int) sampleRepository.count()) ? maxSize : (int) sampleRepository.count();
        final IntStream randomInts = new Random().ints(1, availableCount + 1);
        final IntStream distinctInts = randomInts.distinct();
        distinctInts.limit(availableCount).forEach((int value) -> {
            System.out.println("distinctInt: " + value);
            // todo: select relevant Stimuli and set the Stimulus.Relevance correctly
            stimulusList.add(new Stimulus(sampleRepository.findOne((long) value), Stimulus.Relevance.isIrelevant));
        });
        return stimulusList;
    }

    /**
     * discrimination
     *
     * // todo: this should take input of a vowel pair (because the selection
     * of this vowel pair is yet to be defined)
     *
     * // todo: add parameters of difficulty level, number of speakers in
     * stimuli selection and requireSameStartingConsonent
     *
     * @param maxSize
     * @param targetVowel
     * @param standardVowel
     * @return {sequence of samples with a single target vowel and single
     * standard vowel} a, a, a, e, a, e, e
     */
    public ArrayList<Stimulus> getDiscriminationWords(int maxSize, int maxTargetCount, Vowel targetVowel, Vowel standardVowel) {
        if (targetVowel == null) {
            throw new UnsupportedOperationException();
        }
        if (standardVowel == null) {
            throw new UnsupportedOperationException();
        }
        final List<WordSample> foundByTarget = sampleRepository.findByVowelId(targetVowel.getId());
        final List<WordSample> foundByStandard = sampleRepository.findByVowelId(standardVowel.getId());
        final ArrayList<Stimulus> stimulusList = new ArrayList<>();
//        final int availableCount = (maxSize < (int) sampleRepository.count()) ? maxSize : (int) sampleRepository.count();
        final IntStream randomTargetInts = new Random().ints(0, foundByTarget.size());
        final PrimitiveIterator.OfInt targetRandomIterator = randomTargetInts.iterator();
        final IntStream randomStandardInts = new Random().ints(0, foundByStandard.size());
        final PrimitiveIterator.OfInt standardRandomIterator = randomStandardInts.iterator();
        boolean lastWasTarget = false;
        int targetCounter = 0;
        for (int index = 0; index < maxSize; index++) {
            if (index == 0) {
                stimulusList.add(new Stimulus(foundByTarget.get(targetRandomIterator.nextInt()), Stimulus.Relevance.isIrelevant));
            } else if (index < 4) {
                stimulusList.add(new Stimulus(foundByStandard.get(standardRandomIterator.nextInt()), Stimulus.Relevance.isIrelevant));
            } else {
                if (maxTargetCount > targetCounter) {
                    if (!lastWasTarget) {
                        if (new Random().nextBoolean()) {
                            final WordSample targetStimulus = foundByTarget.get(targetRandomIterator.nextInt());
                            stimulusList.add(new Stimulus(targetStimulus, Stimulus.Relevance.isTarget));
                            targetCounter++;
                            lastWasTarget = true;
                        } else {
                            stimulusList.add(new Stimulus( foundByStandard.get(standardRandomIterator.nextInt()), Stimulus.Relevance.isStandard));
                            lastWasTarget = false;
                        }
                    } else {
                        stimulusList.add(new Stimulus( foundByStandard.get(standardRandomIterator.nextInt()), Stimulus.Relevance.isStandard));
                        lastWasTarget = false;
                    }
                } else {
                    stimulusList.add(new Random().nextInt(stimulusList.size() - 3) + 3, new Stimulus( foundByStandard.get(standardRandomIterator.nextInt()), Stimulus.Relevance.isStandard));
                }
            }
        }
        return stimulusList;
    }

    /**
     * identification
     *
     * // todo: this should take input of a vowel pair (because the selection
     * of this vowel pair is yet to be defined)
     *
     * // todo: add parameters of difficulty level, number of speakers in
     * stimuli selection and requireSameStartingConsonent
     *
     * @param maxSize
     * @return {sequence of samples each with a single target vowel and multiple
     * distinct standard vowels} a, e, a, u, a, i
     */
    public ArrayList<Stimulus> getIdentificationWords(int maxSize) {
        return getRandomWords(maxSize);
    }
}
