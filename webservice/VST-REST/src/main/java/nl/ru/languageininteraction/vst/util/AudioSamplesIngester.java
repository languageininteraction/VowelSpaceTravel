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
import java.util.ArrayList;
import java.util.List;
import javax.imageio.IIOException;
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

    private static final String STIMULI_PATH = "stimuli/";

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
        List<String> excludedWords = new ArrayList<>();
        // the following words are excluded because there are not enough samples for them to be used
        excludedWords.add("beard");
        excludedWords.add("bourse");
        excludedWords.add("cairn");
        excludedWords.add("cheers");
        excludedWords.add("fierce");
        excludedWords.add("kirsch");
        excludedWords.add("pierce");
        excludedWords.add("real");
        try {
            final Resource[] stimuliResources = resourceResolver.getResources("classpath:" + STIMULI_PATH + "*.wav");
            for (Resource currentStimulus : stimuliResources) {
                final String stimulusFileName = currentStimulus.getFilename();
                final String[] splitStimulusName = stimulusFileName.split("_", 2);
                if (splitStimulusName.length > 1) {
                    System.out.println(stimulusFileName);
                    String wordString = splitStimulusName[0];
                    System.out.println("wordString:" + wordString);
                    String speakerString = splitStimulusName[1].substring(0, splitStimulusName[1].length() - ".wav".length());
                    System.out.println("speakerString: " + speakerString);
                    if (excludedWords.contains(wordString)) {
                        System.out.println("excluding: " + wordString);
                    } else {
                        insertSample(wordsRepository.findByWordString(wordString), getSpeaker(speakerString), "/" + STIMULI_PATH + currentStimulus.getFilename());
                    }
                } else {
                    System.out.println("failed to parse: " + stimulusFileName);
                }
            }
        } catch (IOException iOException) {
            throw new IIOException("Error scanning for audio stimuli files!\n"
                    + "These files should be in the following format, {word}_{speaker}.wav\n"
                     +" and be placed in:\n"
                    + "/VowelSpaceTravel/webservice/VST-REST/src/main/resources/stimuli/\n"
                    + iOException.getMessage());
        }
    }
}
