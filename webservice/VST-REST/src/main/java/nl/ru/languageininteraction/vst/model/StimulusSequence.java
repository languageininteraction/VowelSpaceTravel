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
import java.util.Random;
import java.util.stream.IntStream;
import nl.ru.languageininteraction.vst.rest.WordSampleRepository;
import org.springframework.hateoas.ResourceSupport;

/**
 * @since Apr 16, 2015 1:57:15 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class StimulusSequence extends ResourceSupport {

    private ArrayList<Stimulus> stimulusList;
    Player player;

    @JsonCreator
    public StimulusSequence(WordSampleRepository sampleRepository, @JsonProperty("player") Player player) {
        this.player = player;
        stimulusList = new ArrayList<>();
        final int returnCount = 10;
        final IntStream randomInts = new Random().ints(returnCount, 1, (int) sampleRepository.count());
        final IntStream distinctInts = randomInts.distinct();
        distinctInts.forEach((int value) -> {
            System.out.println("distinctInt: " + value);
            // todo: select relevant Stimuli and set the Stimulus.Relevance correctly
            stimulusList.add(new Stimulus(player, sampleRepository.findOne((long) value), Stimulus.Relevance.values()[new Random().nextInt(Stimulus.Relevance.values().length)]));
        });
    }

    public ArrayList<Stimulus> getRandomWords() {
        return stimulusList;
    }
}
