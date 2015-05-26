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
import nl.ru.languageininteraction.vst.model.Confidence;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Vowel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.ExposesResourceFor;
import org.springframework.hateoas.Resources;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @since Apr 23, 2015 5:32:04 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Controller
@ExposesResourceFor(Player.class)
public class ConfidenceController {

    @Autowired
    private PlayerRepository playerRepository;
    @Autowired
    StimulusResponseRepository responseRepository;
    @Autowired
    private VowelRepository vowelRepository;

    @RequestMapping(value = "/confidence", produces = "application/json", method = GET)
    @ResponseBody
    public ResponseEntity<Resources<Confidence>> getConfidenceSequence(@RequestParam(value = "player", required = true) long playerId) {
        final Player player = playerRepository.findById(playerId);
        final ArrayList<Confidence> confidenceList = new ArrayList<>();
        final List<Vowel> allVowels = vowelRepository.findAll();
        for (Vowel targetVowel : allVowels) {
            for (Vowel standarVowel : allVowels) {
                final Confidence confidence = new Confidence(responseRepository, player, targetVowel, standarVowel);
                if (confidence.hasValidConfidence()) {
                    confidenceList.add(confidence);
                }
            }
        }
        Resources<Confidence> resource = new Resources<>(confidenceList);
        resource.add(linkTo(methodOn(ConfidenceController.class).getConfidenceSequence(playerId)).withSelfRel());
        return new ResponseEntity<>(resource, HttpStatus.OK);
    }
}
