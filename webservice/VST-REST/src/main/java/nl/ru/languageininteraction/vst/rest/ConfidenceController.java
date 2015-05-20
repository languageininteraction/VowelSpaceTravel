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
package nl.ru.languageininteraction.vst.rest;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import nl.ru.languageininteraction.vst.model.Confidence;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Vowel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.hateoas.Resources;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.linkTo;
import org.springframework.http.HttpEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @since Apr 23, 2015 5:32:04 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Controller
@RequestMapping("/confidence")
public class ConfidenceController {

    @Autowired
    StimulusResponseRepository responseRepository;
    @Autowired
    private VowelRepository vowelRepository;

    @RequestMapping(value = "/values", method = GET)
    @ResponseBody
    public HttpEntity<Resources<Confidence>> getConfidenceSequence(@Param("player") Player player) {
//        final ConfidenceSequence confidenceSequence = new ConfidenceSequence(wordSampleRepository, null);
        final ArrayList<Confidence> confidenceList = new ArrayList<>();
        final List<Vowel> allVowels = vowelRepository.findAll();
        final Random random = new Random();
        for (Vowel targetVowel : allVowels) {
            for (Vowel standarVowel : allVowels) {
                confidenceList.add(new Confidence(responseRepository, player, targetVowel, standarVowel));
            }
        }
//        for (Confidence confidence : confidenceList) {
//            confidence.add(linkTo(ControllerLinkBuilder.methodOn(ConfidenceController.class).getConfidenceFile(confidence.getSampleId())).withRel("audio"));
//        }
        Resources<Confidence> wrapped = new Resources<>(confidenceList, linkTo(ConfidenceController.class).withSelfRel());
        return new HttpEntity<>(wrapped);
    }
}
