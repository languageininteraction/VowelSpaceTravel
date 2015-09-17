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
package nl.ru.languageininteraction.vst;

import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.rest.ConfidenceRepository;
import nl.ru.languageininteraction.vst.rest.ConsonantRepository;
import nl.ru.languageininteraction.vst.rest.PlayerRepository;
import nl.ru.languageininteraction.vst.rest.ScoreRepository;
import nl.ru.languageininteraction.vst.rest.SettingsRepository;
import nl.ru.languageininteraction.vst.rest.SpeakerRepository;
import nl.ru.languageininteraction.vst.rest.StimulusResponseRepository;
import nl.ru.languageininteraction.vst.rest.VowelQualityRepository;
import nl.ru.languageininteraction.vst.rest.VowelRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;
import nl.ru.languageininteraction.vst.util.AudioSamplesIngester;
import nl.ru.languageininteraction.vst.util.DefaultData;
import nl.ru.languageininteraction.vst.util.PlayerDefaultData;
import nl.ru.languageininteraction.vst.util.StimulusResponseDefaultData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.hateoas.config.EnableEntityLinks;

/**
 * @since Apr 2, 2015 4:58:19 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Configuration
@EnableAutoConfiguration
@ComponentScan
@EnableEntityLinks
public class Application implements CommandLineRunner {

    @Autowired
    private VowelRepository vowelRepository;
    @Autowired
    private VowelQualityRepository vowelQualityRepository;
    @Autowired
    private PlayerRepository playerRepository;
    @Autowired
    private StimulusResponseRepository stimulusResultRepository;
    @Autowired
    private ConfidenceRepository confidenceRepository;
    @Autowired
    private ScoreRepository scoreRepository;
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

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        if (playerRepository.count() == 0) {
            vowelRepository.deleteAll();
            playerRepository.deleteAll();
            wordsRepository.deleteAll();
            stimulusResultRepository.deleteAll();
            consonantRepository.deleteAll();
            speakerRepository.deleteAll();
           

            DefaultData defaultData = new DefaultData(vowelRepository, vowelQualityRepository, playerRepository, stimulusResultRepository, wordsRepository, consonantRepository);
            defaultData.insertVowels();
            defaultData.insertConsonants();
            defaultData.insertWords();
            audioSamplesIngester.processAudioResources();
            new PlayerDefaultData(vowelRepository, playerRepository, stimulusResultRepository, wordsRepository, consonantRepository, settingsRepository).insertPlayer();
            System.out.println("Players");
            for (Player currentPlayer : playerRepository.findAll()) {
                System.out.println(currentPlayer);
            }
            System.out.println();
            new StimulusResponseDefaultData(vowelRepository, playerRepository, stimulusResultRepository, wordsRepository, consonantRepository, confidenceRepository, scoreRepository).insertDummyData();
        }
    }
}
