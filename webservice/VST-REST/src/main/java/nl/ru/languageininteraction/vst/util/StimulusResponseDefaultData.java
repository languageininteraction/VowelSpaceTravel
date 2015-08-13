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

import java.util.ArrayList;
import java.util.List;
import nl.ru.languageininteraction.vst.model.Confidence;
import nl.ru.languageininteraction.vst.model.Difficulty;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Stimulus;
import nl.ru.languageininteraction.vst.model.StimulusResponse;
import nl.ru.languageininteraction.vst.model.Task;
import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.rest.ConfidenceRepository;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;

/**
 * @since Apr 23, 2015 4:36:03 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class StimulusResponseDefaultData {

    private final VowelRepository vowelRepository;
    private final PlayerRepository playerRepository;
    private final StimulusResponseRepository stimulusResultRepository;
    private final WordRepository wordsRepository;
    private final ConsonantRepository consonantRepository;
    private final ConfidenceRepository confidenceRepository;

    public StimulusResponseDefaultData(VowelRepository vowelRepository, PlayerRepository playerRepository, StimulusResponseRepository stimulusResultRepository, WordRepository wordsRepository, ConsonantRepository consonantRepository, ConfidenceRepository confidenceRepository) {
        this.vowelRepository = vowelRepository;
        this.playerRepository = playerRepository;
        this.stimulusResultRepository = stimulusResultRepository;
        this.wordsRepository = wordsRepository;
        this.consonantRepository = consonantRepository;
        this.confidenceRepository = confidenceRepository;
    }

    public void insertDummyData() {
        final Task task = Task.discrimination;
        final Difficulty difficulty = Difficulty.veryhard;
        final Player player = playerRepository.findOne(2L);
        final List<Vowel> allVowels = vowelRepository.findAll();
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, task, difficulty, Stimulus.Relevance.isStandard, false);
        insertConfidence(allVowels, player, task, difficulty);
    }

    private void insertValues(final List<Vowel> allVowels, final Player player, final Task task, final Difficulty difficulty, final Stimulus.Relevance relevance, final boolean playerResponse) {
        for (Vowel targetVowel : allVowels) {
            List<Vowel> remainingVowels = new ArrayList(allVowels);
            remainingVowels.remove(targetVowel);
            for (Vowel standarVowel : remainingVowels) {
                StimulusResponse response = new StimulusResponse(player, task, difficulty, targetVowel, relevance, playerResponse, 1);
                response.addStandardVowel(standarVowel);
                stimulusResultRepository.save(response);
            }
        }
    }

    private void insertConfidence(final List<Vowel> allVowels, final Player player, final Task task, final Difficulty difficulty) {
        List<Vowel> remainingVowels = new ArrayList(allVowels);
        for (Vowel targetVowel : allVowels) {
            remainingVowels.remove(targetVowel);
            for (Vowel standarVowel : remainingVowels) {
                //allVowels.remove(standarVowel);
                Confidence confidence = new Confidence(stimulusResultRepository, player, task, difficulty, targetVowel, standarVowel);
                confidenceRepository.save(confidence);
                confidence = new Confidence(stimulusResultRepository, player, task, difficulty, standarVowel, targetVowel);
                confidenceRepository.save(confidence);
            }
        }
    }

}
