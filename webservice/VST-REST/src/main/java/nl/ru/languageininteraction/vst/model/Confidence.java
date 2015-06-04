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

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import org.apache.commons.math3.stat.interval.ConfidenceInterval;
import org.apache.commons.math3.stat.interval.WilsonScoreInterval;

/**
 * @since Apr 23, 2015 4:11:22 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class Confidence {
// this is the confidence that the application has in the users ability to distinguish a given vowel pair

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
//    @Column(unique = true)
    @ManyToOne
    private Player player;
    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;
    private double confidenceLevel;
    private double lowerBound;
    private double upperBound;
    private boolean hasValidConfidence = false;
    private Task task;
    private Difficulty difficulty;

    public Confidence() {
    }

    public Confidence(StimulusResponseRepository responseRepository, Player player, Task task, Difficulty difficulty, Vowel targetVowel, Vowel standardVowel) {
        this.targetVowel = targetVowel;
        this.standardVowel = standardVowel;
        this.task = task;
        this.difficulty = difficulty;
        this.player = player;
        final int truePositiveCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelsAndRelevanceAndPlayerResponseTrue(player, targetVowel, standardVowel, Stimulus.Relevance.isTarget);
        final int falsePositiveCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelsAndRelevanceAndPlayerResponseTrue(player, targetVowel, standardVowel, Stimulus.Relevance.isStandard);
        final int trueNegativeCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelsAndRelevanceAndPlayerResponseFalse(player, targetVowel, standardVowel, Stimulus.Relevance.isStandard);
        final int falseNegativeCount = responseRepository.countByPlayerAndTargetVowelAndStandardVowelsAndRelevanceAndPlayerResponseFalse(player, targetVowel, standardVowel, Stimulus.Relevance.isTarget);
        calculateConfidence(truePositiveCount, falsePositiveCount, trueNegativeCount, falseNegativeCount);
    }

    public Confidence(final int truePositiveCount, final int falsePositiveCount, final int trueNegativeCount, final int falseNegativeCount) {
        calculateConfidence(truePositiveCount, falsePositiveCount, trueNegativeCount, falseNegativeCount);
    }

    public boolean hasValidConfidence() {
        return hasValidConfidence;
    }

    private void calculateConfidence(final int truePositiveCount, final int falsePositiveCount, final int trueNegativeCount, final int falseNegativeCount) {
        final WilsonScoreInterval wilsonScoreInterval = new WilsonScoreInterval();
        final int numberOfTrials = truePositiveCount + falsePositiveCount + trueNegativeCount + falseNegativeCount;
        final int numberOfSuccesses = truePositiveCount + trueNegativeCount;
        final double confidenceInputLevel = 0.95;
        if (numberOfTrials > 0) {
            final ConfidenceInterval currentInterval = wilsonScoreInterval.createInterval(numberOfTrials, numberOfSuccesses, confidenceInputLevel);
            confidenceLevel = currentInterval.getConfidenceLevel();
            lowerBound = currentInterval.getLowerBound();
            upperBound = currentInterval.getUpperBound();
            hasValidConfidence = true;
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
        return confidenceLevel;
    }

    public double getLowerBound() {
        return lowerBound;
    }

    public double getUpperBound() {
        return upperBound;
    }

    public Player getPlayer() {
        return player;
    }

    public boolean isHasValidConfidence() {
        return hasValidConfidence;
    }

    public Task getTask() {
        return task;
    }

    public Difficulty getDifficulty() {
        return difficulty;
    }

}
