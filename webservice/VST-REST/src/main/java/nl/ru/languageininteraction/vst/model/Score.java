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

import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import nl.ru.languageininteraction.vst.util.TaskScoreCalculator;

/**
 * @since Sep 16, 2015 2:35:45 PM (creation date)
 * @author Karen Dijkstra <k.dijkstra@donders.ru.nl>
 */
@Entity
public class Score {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    
    @ManyToOne
    private Player player;
    private Double score;
    private Double discriminationScore;
    private Double identificationScore;
    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;

    public Score() {
    }
    
    public Score(List<Confidence> retrievedConfidences,Player player, Vowel targetVowel, Vowel standardVowel)
    {
        this.player = player;
        //score = new Random().nextDouble();
        this.standardVowel = standardVowel;
        this.targetVowel = targetVowel;
        calculateScore(retrievedConfidences);
        // TODO: add code to calculate score from confidence values.
    }

    public Player getPlayer() {
        return player;
    }

    public Double getScore() {
        return score;
    }

    public long getTargetId() {
        return targetVowel.getId();
    }

    public long getStandardId() {
        return standardVowel.getId();
    }
    
    public Double getDiscriminationScore() {
        return discriminationScore;
    }

    public Double getIdentificationScore() {
        return identificationScore;
    }

    private void calculateScore(List<Confidence> retrievedConfidences) {
        final double discriminationWeight = 1.0; // lower if perfect discrimination ability should not yet achieve the max score
        final double identificationWeight = 1 - discriminationWeight;
        TaskScoreCalculator identificationCalculator = new TaskScoreCalculator();
        TaskScoreCalculator discriminationCalculator = new TaskScoreCalculator();
        
        for (Confidence element:retrievedConfidences){
            if(element.getTask() == Task.identification)
                identificationCalculator.setScore(element.getPerformance(),element.getDifficulty());
            if(element.getTask() == Task.discrimination)
            {    
                discriminationCalculator.setScore(element.getPerformance(),element.getDifficulty());
            }
            // performance on the harder identification task is a lowerbound estimate for how well someone can do discrimination
            // therefore identification scores are propagated through to discrimination iff they are higher.
            discriminationScore = discriminationCalculator.getTaskScore();
            discriminationCalculator.inheritFromCalculator(identificationCalculator); 
            // score is a weighted average of the task scores. Note that since identification scores are propagated through, so with a 
            // discriminationweight of 1, the identification task score only affects the total score when it is higher than the discrimination
            // score
            score = identificationCalculator.getTaskScore() * identificationWeight +
                     discriminationCalculator.getTaskScore() * discriminationWeight;
            
            identificationScore = identificationCalculator.getTaskScore();
        }
    }
   
   
    
}
