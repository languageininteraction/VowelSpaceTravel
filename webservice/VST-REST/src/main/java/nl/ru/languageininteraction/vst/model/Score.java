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
import java.util.Random;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import nl.ru.languageininteraction.vst.rest.ConfidenceRepository;

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
    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;

    public Score() {
    }
    
    public Score(ConfidenceRepository confidenceRepository,Player player, Vowel targetVowel, Vowel standardVowel)
    {
        this.player = player;
        //score = new Random().nextDouble();
        this.standardVowel = standardVowel;
        this.targetVowel = targetVowel;
        List<Confidence> retrievedConfidences= confidenceRepository.findByPlayerAndTargetVowelAndStandardVowel(player,targetVowel,standardVowel);
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

    private void calculateScore(List<Confidence> retrievedConfidences) {
        final double identificationWeight = 0.5;
        final double discriminationWeight = 1 - identificationWeight;
        TaskScoreCalculator identificationCalculator = new TaskScoreCalculator();
        TaskScoreCalculator discriminationCalculator = new TaskScoreCalculator();
        
        for (Confidence element:retrievedConfidences){
            if(element.getTask() == Task.identification)
                identificationCalculator.setScore(element.getPerformance(),element.getDifficulty());
            if(element.getTask() == Task.discrimination)
            {    
                discriminationCalculator.setScore(element.getPerformance(),element.getDifficulty());
                discriminationCalculator.inheritFromCalculator(identificationCalculator);
            }
            score = identificationCalculator.getTaskScore() * identificationWeight +
                     discriminationCalculator.getTaskScore() * discriminationWeight;
        }
    }
   
    class TaskScoreCalculator {
        
        double easyScore;
        double mediumScore;
        double veryhardScore;
        double hardScore;
        final double weight = 0.25;
        double taskScore;

        public double getTaskScore() {
            calculateScore();
            return taskScore;
        }
        double task;
        
        public TaskScoreCalculator()
        {
            easyScore = 0;
            mediumScore = 0;
            hardScore = 0;
            veryhardScore = 0;
        }
                     
        public void inheritFromCalculator(TaskScoreCalculator calculator)
        {
            if(calculator.veryhardScore > veryhardScore)
                veryhardScore = calculator.veryhardScore;
            if(calculator.hardScore > hardScore )
                hardScore = calculator.hardScore;
            if(calculator.mediumScore > mediumScore )
                mediumScore = calculator.mediumScore;
            if(calculator.easyScore > easyScore )
                easyScore = calculator.easyScore;
        }
        
        private void inheritScore()
        {
            if(veryhardScore > hardScore)
                hardScore = veryhardScore;
            if(hardScore > mediumScore)
                mediumScore = hardScore;
            if(mediumScore > easyScore)
                easyScore = mediumScore;      
        }
        
        public void calculateScore()
        {
            inheritScore();
            taskScore = weight * easyScore + weight * mediumScore + weight * hardScore + weight * veryhardScore;
        }
        
        public void setScore(double performance, Difficulty difficulty) {
            Double rawScore =  performance >= 0.5 ? (performance - 0.5) *2 : 0;  // deduct chance level from perfomance, then multiply to get a score between 0..1
            Double normScore = 2/(1+Math.exp(-(rawScore*6)))-1;
            
            switch(difficulty)
            {
                case easy:
                    easyScore = normScore; break;
                case medium:
                    mediumScore = normScore; break;
                case hard:
                    hardScore = normScore; break;
                case veryhard:
                    veryhardScore = normScore; break;
            }
                    
        }

    }
    
}
