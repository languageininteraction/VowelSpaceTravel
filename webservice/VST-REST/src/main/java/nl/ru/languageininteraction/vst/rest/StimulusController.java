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
import nl.ru.languageininteraction.vst.model.Stimulus;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.*;

import nl.ru.languageininteraction.vst.model.StimulusSequence;
import nl.ru.languageininteraction.vst.model.WordSample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.hateoas.Resources;
import org.springframework.hateoas.mvc.ControllerLinkBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @since Apr 16, 2015 2:25:09 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Controller
@RequestMapping("/stimulus")
public class StimulusController {

    @Autowired
    WordSampleRepository wordSampleRepository;

    @RequestMapping(value = "/audio/{sampleId}", method = RequestMethod.GET, produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE})
    public HttpEntity<InputStreamResource> getStimulusFile(@PathVariable("sampleId") long sampleId) {
        HttpHeaders header = new HttpHeaders();
        header.setContentType(new MediaType("audio", "wav"));
        final WordSample wordSample = wordSampleRepository.findOne(sampleId);
        final InputStreamResource inputStreamResource = new InputStreamResource(StimulusController.class.getResourceAsStream(wordSample.getSoundFilePath()));
//        header.setContentLength(inputStreamResource.contentLength());
        return new HttpEntity<>(inputStreamResource, header);
    }

    @RequestMapping(value = "/random", method = GET)
    @ResponseBody
    public HttpEntity<Resources<Stimulus>> getStimulusSequence() {
        final StimulusSequence stimulusSequence = new StimulusSequence(wordSampleRepository, null);
        final ArrayList<Stimulus> words = stimulusSequence.getRandomWords();
        for (Stimulus stimulus : words) {
            stimulus.add(linkTo(ControllerLinkBuilder.methodOn(StimulusController.class).getStimulusFile(stimulus.getSampleId())).withRel("audio"));
        }
        Resources<Stimulus> wrapped = new Resources<>(words, linkTo(StimulusController.class).withSelfRel());
        return new HttpEntity<>(wrapped);
    }
}