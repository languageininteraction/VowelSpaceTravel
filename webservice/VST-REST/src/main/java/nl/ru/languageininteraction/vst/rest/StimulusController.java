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
import nl.ru.languageininteraction.vst.model.Difficulty;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Stimulus;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.*;

import nl.ru.languageininteraction.vst.model.StimulusSequence;
import nl.ru.languageininteraction.vst.model.Task;
import static nl.ru.languageininteraction.vst.model.Task.discrimination;
import static nl.ru.languageininteraction.vst.model.Task.identification;
import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.model.WordSample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.hateoas.ExposesResourceFor;
import org.springframework.hateoas.Resources;
import org.springframework.hateoas.mvc.ControllerLinkBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @since Apr 16, 2015 2:25:09 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Controller
@ExposesResourceFor(WordSample.class)
//@RepositoryRestResource(collectionResourceRel = "stimulus", path = "stimulus")
//@EnableEntityLinks
@RequestMapping(value = "/stimulus", produces = "application/json")
//@ExposesResourceFor(StimulusController.class)
public class StimulusController {

    @Autowired
    WordSampleRepository wordSampleRepository;

//    @RequestMapping(method = RequestMethod.GET)
//    @ResponseBody
//    public ResponseEntity getLinks() {
//        Resources<Stimulus> wrapped = new Resources<>(null, linkTo(StimulusController.class).withSelfRel());
//        wrapped.add(linkTo(methodOn(StimulusController.class).getStimulusSequence(null, null, null, null, null,null)).withSelfRel());
//        return new ResponseEntity<>(wrapped, HttpStatus.OK);
//    }
//    public StimulusController(EntityLinks entityLinks) {
////        this.entityLinks = entityLinks;
//        entityLinks.linkFor(ControllerLinkBuilder.methodOn(StimulusController.class).getStimulusSequence(discrimination, null, size).withRel("stimulus"));
//    }
//    @RequestMapping(value = "/", method = GET)
//    @ResponseBody
//    public ResponseEntity getStimulusSequence() {
//    Resources<Stimulus> wrapped = new Resources<>(words, linkTo(StimulusController.class).withSelfRel());
//        return new ResponseEntity<>(wrapped, HttpStatus.OK);
//    }
    @RequestMapping(value = "/audio/{sampleId}", method = RequestMethod.GET, produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE})
    @ResponseBody
    public HttpEntity<InputStreamResource> getStimulusFile(@PathVariable("sampleId") long sampleId) {
        HttpHeaders header = new HttpHeaders();
        header.setContentType(new MediaType("audio", "wav"));
        final WordSample wordSample = wordSampleRepository.findOne(sampleId);
        final InputStreamResource inputStreamResource = new InputStreamResource(StimulusController.class.getResourceAsStream(wordSample.getSoundFilePath()));
//        header.setContentLength(inputStreamResource.contentLength());
        return new HttpEntity<>(inputStreamResource, header);
    }

    @RequestMapping(value = "/sequence/{taskType}", method = GET)
    @ResponseBody
    public ResponseEntity<Resources<Stimulus>> getStimulusSequence(@PathVariable("taskType") Task taskType,
            @RequestParam(value = "player", required = true) Player player,
            @RequestParam(value = "difficulty", required = true) Difficulty difficulty,
            @RequestParam(value = "maxSize", required = true) Integer maxSize,
            @RequestParam(value = "maxTargetCount", required = true) Integer maxTargetCount,
            @RequestParam(value = "target", required = true) Vowel targetVowel,
            @RequestParam(value = "standard", required = true) Vowel standardVowel) {
        final StimulusSequence stimulusSequence = new StimulusSequence(wordSampleRepository, player);
        final ArrayList<Stimulus> words;
        switch (taskType) {
            case discrimination:
                words = stimulusSequence.getDiscriminationWords(maxSize, maxTargetCount, targetVowel, standardVowel);
                break;
            case identification:
                words = stimulusSequence.getIdentificationWords(maxSize);
                break;
            default:
                words = stimulusSequence.getRandomWords(maxSize);
                break;
        }
        for (Stimulus stimulus : words) {
            stimulus.add(linkTo(ControllerLinkBuilder.methodOn(StimulusController.class).getStimulusFile(stimulus.getSampleId())).withRel("audio"));
        }
        Resources<Stimulus> wrapped = new Resources<>(words, linkTo(StimulusController.class).withSelfRel());
        return new ResponseEntity<>(wrapped, HttpStatus.OK);
    }

    @RequestMapping(value = "/response", method = POST)
    @ResponseBody
//    public ResponseEntity<Resources<Confidence>> postStimulusSequence(
    public ResponseEntity postStimulusSequence(
            //            @RequestParam(value = "player", required = true) Player player,
            //            Player player,
            @RequestBody List<Stimulus> results) {
//        System.out.println("player:" + player.getEmail());
        System.out.println("stimulus: " + results.size());
//        Resources<Confidence> wrapped = new Resources<>());
        for (Stimulus stimulus : results) {
            System.out.println(stimulus.getPlayerResponse());
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
