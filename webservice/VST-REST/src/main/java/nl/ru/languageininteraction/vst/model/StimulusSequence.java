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
import org.springframework.hateoas.ResourceSupport;

/**
 * @since Apr 16, 2015 1:57:15 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class StimulusSequence extends ResourceSupport {

    private ArrayList<WordSample> wordSamples;
    Player player;

    @JsonCreator
    public StimulusSequence(@JsonProperty("player") Player player) {
        this.player = player;
        wordSamples = new ArrayList<>();
//        final Word word = new Word("woof", new Consonant("w"), new Vowel("o:", "o", Vowel.Place.back, Vowel.Manner.close, Vowel.Roundness.rounded), new Consonant("f"));
//        wordSamples.add(new WordSample(new Speaker("cat"), word, "somewherefile"));
//        wordSamples.add(new WordSample(new Speaker("cow"), word, "greenpastures"));
    }

    public ArrayList<WordSample> getWords() {
        return wordSamples;
    }
}
