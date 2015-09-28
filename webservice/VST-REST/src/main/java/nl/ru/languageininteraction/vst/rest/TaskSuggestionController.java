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
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import nl.ru.languageininteraction.vst.model.Confidence;
import nl.ru.languageininteraction.vst.model.Difficulty;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.Stimulus;
import nl.ru.languageininteraction.vst.model.StimulusResponse;
import nl.ru.languageininteraction.vst.model.Task;
import nl.ru.languageininteraction.vst.model.TaskSuggestion;
import nl.ru.languageininteraction.vst.model.Vowel;
import nl.ru.languageininteraction.vst.model.VowelPair;
import org.apache.commons.math3.distribution.NormalDistribution;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.hateoas.Resource;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.linkTo;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @since Jul 10, 2015 11:57:16 AM (creation date)
 * @author Karen Dijkstra <k.dijkstra@donders.ru.nl>
 */
@Controller
@RequestMapping(value = "/suggestion", produces = "application/json")
public class TaskSuggestionController {

    private final double confidenceTreshold = 0.8;
    private final int referencePoint = 2;
    private final int window = 30;
    // private Date referenceDate = null;
    @Autowired
    ConfidenceRepository confidenceRepository;
    @Autowired
    StimulusResponseRepository responseRepository;
    @Autowired
    VowelRepository vowelRepository;

    @RequestMapping(value = "/tasksuggestion/{player}", method = GET)
    @ResponseBody
    public ResponseEntity<Resource<TaskSuggestion>> getTaskSuggestion(@PathVariable("player") Player player) {
        TaskSuggestion suggestion;
        if (noCurrentVowelPair(player)) {
            suggestion = selectNewVowelPairAndSettings(player);
        } else {
            suggestion = determineSettingsforVowelPair(player);
        }
        Resource<TaskSuggestion> wrapped = new Resource<>(suggestion, linkTo(TaskSuggestionController.class).withSelfRel());
        return new ResponseEntity<>(wrapped, HttpStatus.OK);
    }

    private boolean noCurrentVowelPair(Player player) {
        //StimulusResponse latestResponse = responseRepository.findTop10ByPlayerOrderByResponseDateDesc(player).get(0);
        Date sessionDate = getSessionDate();
        List<StimulusResponse> recentData = responseRepository.findFirstByPlayerAndResponseDateGreaterThan(player, sessionDate);
        System.out.println(recentData.isEmpty());
        return recentData.isEmpty();
    }

    private TaskSuggestion selectNewVowelPairAndSettings(Player player) {
        List<Confidence> confList = confidenceRepository.findByPlayerAndTaskAndDifficultyOrderByLowerBoundAsc(player, Task.discrimination, Difficulty.veryhard);
        // List <Confidence> allConf = confidenceRepository.findAll();
        List<Vowel> allVowels = vowelRepository.findAll();
        List<VowelPair> vowelPairs = new ArrayList();
        for (Vowel vowelA : allVowels) {
            List<Vowel> remainingVowels = new ArrayList(allVowels);
            remainingVowels.remove(vowelA);
            for (Vowel vowelB : remainingVowels) {
                vowelPairs.add(new VowelPair(vowelA, vowelB));
            }
        }
        List<VowelPair> currentVowelPairs = new ArrayList(vowelPairs);
        
        if (confList.isEmpty()) {
            return new TaskSuggestion(vowelPairs);
        }
      
        Date sessionDate = getSessionDate();
        Iterator<Confidence> iterator = confList.iterator();
        while (iterator.hasNext()) {
            Confidence next = iterator.next();
            // If stimulus response for this day, this player, this vowel pair in difficulty veryhard exists, move on to next.
            StimulusResponse response = responseRepository.findFirstByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsAndResponseDateGreaterThan(player,
                    next.getTask(), Difficulty.veryhard, next.getStandardVowel(), next.getTargetVowel(), sessionDate);
            if (response != null) {
                currentVowelPairs.remove(new VowelPair(next.getTargetVowel(), next.getStandardVowel()));
                continue;
            }
            response = responseRepository.findFirstByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsAndResponseDateGreaterThan(player,
                    next.getTask(), Difficulty.veryhard, next.getTargetVowel(), next.getStandardVowel(), sessionDate);
            if (response == null) {
                return new TaskSuggestion(next);
            }
            currentVowelPairs.remove(new VowelPair(next.getTargetVowel(), next.getStandardVowel()));
        }
        // referenceDate = new Date();
        if (currentVowelPairs.isEmpty()) {
            return new TaskSuggestion(vowelPairs);
        } else {
            return new TaskSuggestion(currentVowelPairs);
        }
        //throw new UnsupportedOperationException("Unsupported");
    }

    private TaskSuggestion determineSettingsforVowelPair(Player player) {
        StimulusResponse lastResponse = responseRepository.findFirstByPlayerOrderByResponseDateDesc(player);
        if (lastResponse == null) {
            return selectNewVowelPairAndSettings(player);
        }
        List<StimulusResponse> data = getRecentDataWindow(0, window, lastResponse, player);

        int correct = positiveCount(data);
        Confidence confData = new Confidence(correct, data.size() - correct, 0, 0);
        if (confData.getLowerBound() >= confidenceTreshold) {
            return selectNewVowelPairAndSettings(player);
        }

        if (data.size() < window) {
            return new TaskSuggestion(data.get(0));
        }

        List<StimulusResponse> referenceData = getRecentDataWindow(referencePoint, window, lastResponse, player);
        if ((referenceData.size() < window) || detected_improvement(player, data, referenceData)) {
            return new TaskSuggestion(data.get(0));
        } else if (lastResponse.getDifficulty() == Difficulty.easy) {
            return selectNewVowelPairAndSettings(player);
        } else {
            TaskSuggestion task = new TaskSuggestion(data.get(0));
            task.lowerDifficulty();
            return task;
        }
    }

    private List<StimulusResponse> getRecentDataWindow(int page, int windowlength, StimulusResponse response, Player player) {
        List<StimulusResponse> data;
        if (response.getTask() == Task.discrimination) {

            // To do: Test if last page 2 is less recent than page 0
            data = responseRepository.findByPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsOrPlayerAndTaskAndDifficultyAndTargetVowelAndStandardVowelsOrderByResponseDateDesc(
                    player, Task.discrimination,
                    response.getDifficulty(),
                    response.getTargetVowel(),
                    response.getStandardVowels().get(0),
                    player, Task.discrimination,
                    response.getDifficulty(),
                    response.getStandardVowels().get(0),
                    response.getTargetVowel(),
                    new PageRequest(page, windowlength));
        } else if (response.getTask() == Task.identification) {
            data = responseRepository.findTop30ByPlayerAndTaskAndDifficultyAndTargetVowelOrderByResponseDateDesc(
                    player, Task.identification,
                    response.getDifficulty(),
                    response.getTargetVowel());
        } else {
            throw new UnsupportedOperationException("Unsupported task");
        }
        return data;
    }

    private Date getSessionDate() {
        // if (referenceDate == null) {
        Calendar c = Calendar.getInstance();

        // set the calendar to start of today
        c.set(Calendar.HOUR_OF_DAY, 0);
        c.set(Calendar.MINUTE, 0);
        c.set(Calendar.SECOND, 0);
        c.set(Calendar.MILLISECOND, 0);

        // and get that as a Date
        return c.getTime();
        //  }
        //  else
        //      return referenceDate;

    }

    private boolean detected_improvement(Player player, List<StimulusResponse> currentData, List<StimulusResponse> referenceData) {
        int totalCurr = currentData.size();
        int totalRef = referenceData.size();
        int positiveCurr = positiveCount(currentData);
        int positiveRef = positiveCount(referenceData);
        double zScore = getZScore(positiveCurr, positiveRef, totalCurr, totalRef);
        double pValue = new NormalDistribution(null, 0, 1).cumulativeProbability(zScore);
        double alpha = 0.05;
        return (pValue < alpha);
    }

    public double getZScore(double X1, double X2, double n1, double n2) {
        double p = (X1 + X2) * 1.0 / (n1 + n2);
        double sError = Math.sqrt(p * (1 - p) * ((1 / n1) + (1 / n2)));
        return ((X1 / n1) - (X2 / n2)) / sError;
    }

    private int positiveCount(List<StimulusResponse> data) {
        Iterator<StimulusResponse> iterator = data.iterator();
        int correct = 0;
        String std = data.get(0).getStandardVowels().get(0).getDisc();
        System.out.println("Datawindow dates: " + data.get(0).getTargetVowel().getDisc() + " " + std);
        while (iterator.hasNext()) {
            StimulusResponse next = iterator.next();
            System.out.println(next.getResponseDate().toString());
            if (next.getRelevance() == Stimulus.Relevance.isIrelevant) {
                throw new UnsupportedOperationException("Irrelevant responses cannot be considered");
            }
            if (next.getResponseRating() == StimulusResponse.ResponseRating.true_negative
                    || next.getResponseRating() == StimulusResponse.ResponseRating.true_positive) {
                correct++;
            }
        }
        return correct;
    }

}
