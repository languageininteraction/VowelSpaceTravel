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

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;

/**
 * @since Apr 8, 2015 11:23:48 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class StimulusResponse { //extends ResourceSupport

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @ManyToOne
    private Player player;

    @ManyToOne
    private Vowel targetVowel;

    @ManyToMany
    private List<Vowel> standardVowels = new ArrayList<>();
    private Task taskType;
    private Difficulty difficulty;

    public enum ResponseRating {

        true_positive,
        false_positive,
        true_negative,
        false_negative
    }
//    private ResponseRating responseRating;
    
    @Enumerated(EnumType.STRING)
    Stimulus.Relevance relevance;
    boolean playerResponse;
    private long responseTimeMs;
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date responseDate;

    public StimulusResponse(Player player, Vowel targetVowel, Stimulus.Relevance relevance, boolean playerResponse, long responseTimeMs) {
        this.player = player;
        this.targetVowel = targetVowel;
        this.relevance = relevance;
        this.playerResponse = playerResponse;
        this.responseTimeMs = responseTimeMs;
        this.responseDate = new Date();
    }

    public StimulusResponse() {
    }

    public Player getPlayer() {
        return player;
    }

    public Vowel getTargetVowel() {
        return targetVowel;
    }

    public List<Vowel> getStandardVowels() {
        return standardVowels;
    }

    public void addStandardVowel(Vowel standardVowel) {
        standardVowels.add(standardVowel);
    }

    public Stimulus.Relevance getRelevance() {
        return relevance;
    }

    public boolean isPlayerResponse() {
        return playerResponse;
    }

    public ResponseRating getResponseRating() {
        ResponseRating responseRating;
        if (relevance.equals(Stimulus.Relevance.isTarget)) {
            if (playerResponse) {
                responseRating = ResponseRating.true_positive;
            } else {
                responseRating = ResponseRating.false_negative;
            }
        } else if (playerResponse) {
            responseRating = ResponseRating.false_positive;
        } else {
            responseRating = ResponseRating.true_negative;
        }
        return responseRating;
    }

    public long getResponseTimeMs() {
        return responseTimeMs;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public Task getTaskType() {
        return taskType;
    }

    public void setTaskType(Task taskType) {
        this.taskType = taskType;
    }

    public Difficulty getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(Difficulty difficulty) {
        this.difficulty = difficulty;
    }
}
