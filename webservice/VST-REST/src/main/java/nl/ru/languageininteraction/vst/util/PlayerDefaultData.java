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

import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.SettingsRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;

/**
 * @since Apr 23, 2015 4:57:23 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class PlayerDefaultData {

    private final VowelRepository vowelRepository;
    private final PlayerRepository playerRepository;
    private final StimulusResponseRepository stimulusResultRepository;
    private final WordRepository wordsRepository;
    private final ConsonantRepository consonantRepository;
    private final SettingsRepository settingsRepository;

    public PlayerDefaultData(VowelRepository vowelRepository, PlayerRepository playerRepository, StimulusResponseRepository stimulusResultRepository, WordRepository wordsRepository, ConsonantRepository consonantRepository, SettingsRepository settingsRepository) {
        this.vowelRepository = vowelRepository;
        this.playerRepository = playerRepository;
        this.stimulusResultRepository = stimulusResultRepository;
        this.wordsRepository = wordsRepository;
        this.consonantRepository = consonantRepository;
        this.settingsRepository = settingsRepository;
    }

    public void insertPlayer() {
//        final Settings settings = new Settings();
        final Player player1 = new Player("Jane", "Smith", "jane@bsmoth.none", "1234", null,false,null);
        playerRepository.save(player1);
        final Player player2 = new Player("Fred", "Blogs", "fred@blogs.none", "1234", null,false,null);
        playerRepository.save(player2);
    }
}
