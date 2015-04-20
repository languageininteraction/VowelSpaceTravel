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

import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;

/**
 * @since Apr 20, 2015 11:35:57 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class DefaultData {

    private final VowelRepository vowelRepository;
    private final PlayerRepository playerRepository;
    private final StimulusResponseRepository stimulusResultRepository;
    private final WordRepository wordsRepository;
    private final ConsonantRepository consonantRepository;

    public DefaultData(VowelRepository vowelRepository, PlayerRepository playerRepository, StimulusResponseRepository stimulusResultRepository, WordRepository wordsRepository, ConsonantRepository consonantRepository) {
        this.vowelRepository = vowelRepository;
        this.playerRepository = playerRepository;
        this.stimulusResultRepository = stimulusResultRepository;
        this.wordsRepository = wordsRepository;
        this.consonantRepository = consonantRepository;
    }

    public void insertConsonants() {
//        consonantRepository.save(new Consonant("W"));
    }

    public void insertVowels() {
        vowelRepository.save(new Vowel("I", "I", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("E", "E", Vowel.Place.front, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("{", "{", Vowel.Place.front, Vowel.Manner.near_open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("V", "V", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("Q", "Q", Vowel.Place.back, Vowel.Manner.open, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("U", "U", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("i", "i", Vowel.Place.front, Vowel.Manner.close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("#", "#", Vowel.Place.back, Vowel.Manner.open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("$", "$", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("u", "u", Vowel.Place.back, Vowel.Manner.close, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("3", "3", Vowel.Place.central, Vowel.Manner.open_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("1", "1", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("2", "2", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("4", "4", Vowel.Place.near_front, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("5", "5", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("6", "6", Vowel.Place.near_back, Vowel.Manner.near_close, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("1", "1", Vowel.Place.front, Vowel.Manner.close_mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("2", "2", Vowel.Place.front, Vowel.Manner.open, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("4", "4", Vowel.Place.back, Vowel.Manner.open_mid, Vowel.Roundness.rounded));
        vowelRepository.save(new Vowel("5", "5", Vowel.Place.central, Vowel.Manner.mid, Vowel.Roundness.unrounded));
        vowelRepository.save(new Vowel("6", "6", Vowel.Place.front, Vowel.Manner.open, Vowel.Roundness.unrounded));
    }
}
