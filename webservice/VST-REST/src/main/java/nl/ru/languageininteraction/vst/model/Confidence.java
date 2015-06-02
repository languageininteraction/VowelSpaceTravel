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

import javax.persistence.ManyToOne;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import org.apache.commons.math3.stat.interval.ConfidenceInterval;
import org.apache.commons.math3.stat.interval.WilsonScoreInterval;

/**
 * @since Apr 23, 2015 4:11:22 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class Confidence {
// this is the confidence that the application has in the users ability to distinguish a given vowel pair

    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;
    final ConfidenceInterval confidenceInterval;
    Task task;
    Difficulty difficulty;

    public Confidence(StimulusResponseRepository responseRepository, Player player, Vowel targetVowel, Vowel standardVowel) {
        this.targetVowel = targetVowel;
        this.standardVowel = standardVowel;
        final int truePositiveCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelAndIsCorrectTrueAndPlayerResponseTrue(player, targetVowel, standardVowel);
        final int falsePositiveCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelAndIsCorrectFalseAndPlayerResponseTrue(player, targetVowel, standardVowel);
        final int trueNegativeCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelAndIsCorrectFalseAndPlayerResponseFalse(player, targetVowel, standardVowel);
        final int falseNegativeCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelAndIsCorrectTrueAndPlayerResponseFalse(player, targetVowel, standardVowel);
        confidenceInterval = calculateConfidence(truePositiveCount, falsePositiveCount, trueNegativeCount, falseNegativeCount);
    }

    public Confidence(final int truePositiveCount, final int falsePositiveCount, final int trueNegativeCount, final int falseNegativeCount) {
        confidenceInterval = calculateConfidence(truePositiveCount, falsePositiveCount, trueNegativeCount, falseNegativeCount);
    }

    public boolean hasValidConfidence() {
        return confidenceInterval != null;
    }

    private ConfidenceInterval calculateConfidence(final int truePositiveCount, final int falsePositiveCount, final int trueNegativeCount, final int falseNegativeCount) {
        final WilsonScoreInterval wilsonScoreInterval = new WilsonScoreInterval();
        final int numberOfTrials = truePositiveCount + falsePositiveCount + trueNegativeCount + falseNegativeCount;
        final int numberOfSuccesses = truePositiveCount + trueNegativeCount;
        final double confidenceLevel = 0.95;
        if (numberOfTrials > 0) {
            return wilsonScoreInterval.createInterval(numberOfTrials, numberOfSuccesses, confidenceLevel);
        } else {
            return null;
        }
    }

    public Vowel getTargetVowel() {
        return targetVowel;
    }

    public Vowel getStandardVowel() {
        return standardVowel;
    }

    public long getTargetId() {
        return targetVowel.getId();
    }

    public long getStandardId() {
        return standardVowel.getId();
    }

    public double getConfidenceLevel() {
        return confidenceInterval.getConfidenceLevel();
    }

    public double getLowerBound() {
        return confidenceInterval.getLowerBound();
    }

    public double getUpperBound() {
        return confidenceInterval.getUpperBound();
    }
}
