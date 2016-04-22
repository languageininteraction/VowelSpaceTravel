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
package nl.ru.languageininteraction.vst.util;

import nl.ru.languageininteraction.vst.model.Difficulty;

/**
 * @since Oct 5, 2015 4:39:25 PM (creation date)
 * @author Karen Dijkstra <k.dijkstra@donders.ru.nl>
 */
public class TaskScoreCalculator {

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

    public TaskScoreCalculator() {
        easyScore = 0;
        mediumScore = 0;
        hardScore = 0;
        veryhardScore = 0;
    }

    public void inheritFromCalculator(TaskScoreCalculator calculator) {
        if (calculator.veryhardScore > veryhardScore) {
            veryhardScore = calculator.veryhardScore;
        }
        if (calculator.hardScore > hardScore) {
            hardScore = calculator.hardScore;
        }
        if (calculator.mediumScore > mediumScore) {
            mediumScore = calculator.mediumScore;
        }
        if (calculator.easyScore > easyScore) {
            easyScore = calculator.easyScore;
        }
    }

    private void inheritScore() {
        if (veryhardScore > hardScore) {
            hardScore = veryhardScore;
        }
        if (hardScore > mediumScore) {
            mediumScore = hardScore;
        }
        if (mediumScore > easyScore) {
            easyScore = mediumScore;
        }
    }

    public void calculateScore() {
        inheritScore();
        taskScore = weight * easyScore + weight * mediumScore + weight * hardScore + weight * veryhardScore;
    }

    public void setScore(double performance, Difficulty difficulty) {
        Double rawScore = performance >= 0.5 ? (performance - 0.5) * 2 : 0;  // deduct chance level from perfomance, then multiply to get a score between 0..1
        Double normScore = 2 / (1 + Math.exp(-(rawScore * 6))) - 1;

        switch (difficulty) {
            case easy:
                easyScore = normScore;
                break;
            case medium:
                mediumScore = normScore;
                break;
            case hard:
                hardScore = normScore;
                break;
            case veryhard:
                veryhardScore = normScore;
                break;
        }

    }

}
