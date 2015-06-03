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

import java.util.List;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Stimulus;
import nl.ru.languageininteraction.vst.model.StimulusResponse;
import nl.ru.languageininteraction.vst.model.Vowel;
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

    public StimulusResponseDefaultData(VowelRepository vowelRepository, PlayerRepository playerRepository, StimulusResponseRepository stimulusResultRepository, WordRepository wordsRepository, ConsonantRepository consonantRepository) {
        this.vowelRepository = vowelRepository;
        this.playerRepository = playerRepository;
        this.stimulusResultRepository = stimulusResultRepository;
        this.wordsRepository = wordsRepository;
        this.consonantRepository = consonantRepository;
    }

    public void insertDummyData() {
        final Player player = playerRepository.findOne(0L);
        final List<Vowel> allVowels = vowelRepository.findAll();
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isTarget, false);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, true);
        insertValues(allVowels, player, Stimulus.Relevance.isStandard, false);
    }

    private void insertValues(final List<Vowel> allVowels, final Player player, final Stimulus.Relevance relevance, final boolean playerResponse) {
        for (Vowel targetVowel : allVowels) {
            for (Vowel standarVowel : allVowels) {
                StimulusResponse response = new StimulusResponse(player, targetVowel, relevance, playerResponse, 1);
                response.addStandardVowel(standarVowel);
                stimulusResultRepository.save(response);
            }
        }
    }
}
