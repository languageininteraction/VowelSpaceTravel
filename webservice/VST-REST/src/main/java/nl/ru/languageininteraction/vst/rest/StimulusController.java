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

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import nl.ru.languageininteraction.vst.model.Confidence;
import nl.ru.languageininteraction.vst.model.Difficulty;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Score;
import nl.ru.languageininteraction.vst.model.Stimulus;
import nl.ru.languageininteraction.vst.model.StimulusResponse;
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
    @Autowired
    StimulusResponseRepository responseRepository;
    @Autowired
    ConfidenceRepository confidenceRepository;
    @Autowired
    VowelRepository vowelRepository;
    @Autowired
    ScoreRepository scoreRepository;
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

    @RequestMapping(value = "/sequence/{taskType}/{difficulty}/{player}", method = GET)
    @ResponseBody
    public ResponseEntity<Resources<Stimulus>> getStimulusSequence(
            @PathVariable("taskType") Task taskType,
            @PathVariable("player") Player player,
            @PathVariable("difficulty") Difficulty difficulty,
            @RequestParam(value = "maxSize", required = true) Integer maxSize,
            @RequestParam(value = "maxTargetCount", required = true) Integer maxTargetCount,
            @RequestParam(value = "target", required = true) Vowel targetVowel,
            @RequestParam(value = "standard", required = true) Vowel standardVowel) {
        final StimulusSequence stimulusSequence = new StimulusSequence(wordSampleRepository, player,vowelRepository);
        final ArrayList<Stimulus> words;
        switch (taskType) {
            case discrimination:
                words = stimulusSequence.getDiscriminationWords(maxSize, maxTargetCount, targetVowel, standardVowel, difficulty);
                break;
            case identification:
                words = stimulusSequence.getIdentificationWords(maxSize, maxTargetCount, targetVowel, difficulty);
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

    @RequestMapping(value = "/response/{taskType}/{difficulty}/{player}", method = POST)
    @ResponseBody
    public ResponseEntity postStimulusSequence(
            @PathVariable("taskType") Task taskType,
            @PathVariable("player") Player player,
            @PathVariable("difficulty") Difficulty difficulty,
            @RequestBody List<Stimulus> results,
            Principal principal) {
        System.out.println("difficulty:" + difficulty);
        System.out.println("taskType:" + taskType);
        System.out.println("player:" + player.getEmail());
        System.out.println("stimulus: " + results.size());
        System.out.println("principal:" + principal.getName());
        if (!principal.getName().equals(player.getEmail())) {
            return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        }
        HashSet<Vowel> standardVowels = new HashSet<>();
        Vowel targetVowel = null;
        for (Stimulus stimulus : results) {
            if (Stimulus.Relevance.isStandard.equals(stimulus.getRelevance())) {
                standardVowels.add(vowelRepository.findOne(stimulus.getVowelId()));
            } else if (targetVowel == null && Stimulus.Relevance.isTarget.equals(stimulus.getRelevance())) {
                targetVowel = vowelRepository.findOne(stimulus.getVowelId());
            }
        }
        for (Stimulus stimulus : results) {
            System.out.println(stimulus.getPlayerResponse());
            System.out.println(stimulus.getResponseDate());
            System.out.println(stimulus.getResponseTimeMs());
            System.out.println(stimulus.getWordSample());
            System.out.println(stimulus.getRelevance());
            System.out.println(stimulus.getSampleId());
            System.out.println(stimulus.getVowelId());
            if (stimulus.getPlayerResponse() != null) {
                final StimulusResponse stimulusResponse = new StimulusResponse(player, taskType, difficulty, targetVowel, stimulus.getRelevance(), stimulus.getPlayerResponse(), stimulus.getResponseTimeMs());
                if (stimulus.getRelevance().equals(Stimulus.Relevance.isStandard)) {
                    stimulusResponse.addStandardVowel(vowelRepository.findOne(stimulus.getVowelId()));
                } else if (stimulus.getRelevance().equals(Stimulus.Relevance.isTarget)) {
                    stimulusResponse.addStandardVowels(standardVowels);
                }
                responseRepository.save(stimulusResponse);
            }
        }
        // update and save all confidence values
        for (Vowel standardVowel : standardVowels) {
            confidenceRepository.deleteByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowel(player, taskType, difficulty, targetVowel, standardVowel);
            confidenceRepository.save(new Confidence(responseRepository, player, taskType, difficulty, targetVowel, standardVowel));
            confidenceRepository.deleteByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowel(player, taskType, difficulty, standardVowel, targetVowel);
            confidenceRepository.save(new Confidence(responseRepository, player, taskType, difficulty, standardVowel, targetVowel));
            
            scoreRepository.deleteByPlayerAndTargetVowelAndStandardVowel(player, targetVowel, standardVowel);
            scoreRepository.save(new Score(confidenceRepository,player,targetVowel,standardVowel));
            scoreRepository.deleteByPlayerAndTargetVowelAndStandardVowel(player, standardVowel, targetVowel);
            scoreRepository.save(new Score(confidenceRepository,player,standardVowel,targetVowel));
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
