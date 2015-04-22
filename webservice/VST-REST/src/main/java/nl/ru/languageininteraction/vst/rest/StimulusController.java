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

import javax.servlet.http.HttpServletResponse;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.*;

import nl.ru.languageininteraction.vst.model.StimulusSequence;
import nl.ru.languageininteraction.vst.model.WordSample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.hateoas.mvc.ControllerLinkBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
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

    @RequestMapping(value = "/audio/{id}", method = RequestMethod.GET, produces = {MediaType.APPLICATION_OCTET_STREAM_VALUE})
    public HttpEntity<InputStreamResource> getStimulusFile(@PathVariable("id") long id, ModelMap model, HttpServletResponse response) {
        HttpHeaders header = new HttpHeaders();
        header.setContentType(new MediaType("audio", "wav"));
        final WordSample wordSample = wordSampleRepository.findOne(id);
        final InputStreamResource inputStreamResource = new InputStreamResource(StimulusController.class.getResourceAsStream(wordSample.getSoundFilePath()));
//        header.setContentLength(inputStreamResource.contentLength());
        return new HttpEntity<>(inputStreamResource, header);
    }

    @RequestMapping(method = GET)
    @ResponseBody
//    @RequestMapping("/next")
    public HttpEntity<StimulusSequence> getStimulusSequence() {
        final StimulusSequence stimulusSequence = new StimulusSequence(null);
        stimulusSequence.add(linkTo(ControllerLinkBuilder.methodOn(StimulusController.class).getStimulusSequence()).withSelfRel());
//        stimuli.add(linkTo(ControllerLinkBuilder.methodOn(StimulusController.class).getFile()).withSelfRel());
        return new ResponseEntity<>(stimulusSequence, HttpStatus.OK);
    }
//    @RequestMapping(method = GET)
//    @ResponseBody
////    @RequestMapping("/next")
//    public HttpEntity<Stimuli> getStimulusSequence(@RequestParam(value = "player", required = true) Player player) {
//        final StimulusSequence stimuli = new StimulusSequence(player);
//        stimuli.add(linkTo(ControllerLinkBuilder.methodOn(StimulusController.class).getStimulusSequence(player)).withSelfRel());
//        return new ResponseEntity<>(stimuli, HttpStatus.OK);
//    }
}
