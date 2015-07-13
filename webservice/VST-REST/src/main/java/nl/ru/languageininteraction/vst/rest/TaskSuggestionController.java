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
import nl.ru.languageininteraction.vst.model.Task;
import nl.ru.languageininteraction.vst.model.TaskSuggestion;
import org.springframework.hateoas.Resources;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.linkTo;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 *
 * @author Karen
 */
public class TaskSuggestionController {

    private final ConfidenceRepository confidenceRepository;
    private final StimulusResponseRepository responseRepository;

    public TaskSuggestionController(ConfidenceRepository confidenceRepository, StimulusResponseRepository responseRepository) {
        this.confidenceRepository = confidenceRepository;
        this.responseRepository = responseRepository;
    }

    @RequestMapping(value = "/tasksuggestion/{player}", method = GET)
    @ResponseBody
    public ResponseEntity<Resources<TaskSuggestion>> getTaskSuggestion(@PathVariable("player") Player player) {
        ArrayList<TaskSuggestion> suggestions = new ArrayList<>();
        // todo: add suggestions
        TaskSuggestion suggestion = new TaskSuggestion(Task.discrimination,Difficulty.veryhard,null,null);
        suggestions.add(suggestion);
        Resources<TaskSuggestion> wrapped = new Resources<>(suggestions, linkTo(TaskSuggestionController.class).withSelfRel());
        return new ResponseEntity<>(wrapped, HttpStatus.OK);
    }
}
