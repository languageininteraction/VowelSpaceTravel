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

import java.io.IOException;
import nl.ru.languageininteraction.vst.model.Speaker;
import nl.ru.languageininteraction.vst.model.Word;
import nl.ru.languageininteraction.vst.model.WordSample;
import nl.ru.languageininteraction.vst.rest.SpeakerRepository;
import nl.ru.languageininteraction.vst.rest.WordRepository;
import nl.ru.languageininteraction.vst.rest.WordSampleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.springframework.stereotype.Service;

/**
 * @since Apr 22, 2015 11:11:44 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Service
public class AudioSamplesIngester {

    @Autowired
    ResourcePatternResolver resourceResolver;
    @Autowired
    private WordRepository wordsRepository;
    @Autowired
    private WordSampleRepository wordSampleRepository;
    @Autowired
    private SpeakerRepository speakerRepository;

    private Speaker getSpeaker(String speakerString) {
        Speaker findByLabel = speakerRepository.findByLabel(speakerString);
        if (findByLabel == null) {
            findByLabel = speakerRepository.save(new Speaker(speakerString));
        }
        return findByLabel;
    }

    private void insertSample(Word word, Speaker speaker, String path) {
        wordSampleRepository.save(new WordSample(speaker, word, path));
    }

    public void processAudioResources() throws IOException {
        System.out.println("processAudioResources");
        final Resource[] stimuliResources = resourceResolver.getResources("classpath:stimuli/*.wav");
        for (Resource currentStimulus : stimuliResources) {
            final String stimulusFileName = currentStimulus.getFile().getName();
            final String[] splitStimulusName = stimulusFileName.split("_", 2);
            if (splitStimulusName.length > 1) {
                System.out.println(stimulusFileName);
                String wordString = splitStimulusName[0];
                System.out.println("wordString:" + wordString);
                String speakerString = splitStimulusName[1].substring(0, splitStimulusName[1].length() - ".wav".length());
                System.out.println("speakerString: " + speakerString);
                insertSample(wordsRepository.findByWordString(wordString), getSpeaker(speakerString), currentStimulus.getFilename());
            } else {
                System.out.println("failed to parse: " + stimulusFileName);
            }
        }
    }
}
