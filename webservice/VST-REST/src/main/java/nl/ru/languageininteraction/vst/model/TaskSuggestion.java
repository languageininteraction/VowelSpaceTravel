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

/**
 *
 * @author Karen
 */
public class TaskSuggestion {

    final private Task task;
    private Difficulty difficulty;
    private Vowel targetVowel;
    private Vowel standardVowel;

    public TaskSuggestion(List vowels, Task task) {

        this.task = task;
        difficulty = Difficulty.veryhard;
        if (task == Task.discrimination) {
            VowelPair vowelPair = (VowelPair) vowels.get(new Random().nextInt(vowels.size()));
            targetVowel = vowelPair.getVowelA();
            standardVowel = vowelPair.getVowelB();
        } else {
            targetVowel = (Vowel) vowels.get(new Random().nextInt(vowels.size()));
            standardVowel = null;
        }
    }

    public TaskSuggestion(Task task, Difficulty difficulty, Vowel targetVowel, Vowel standardVowel) {
        this.task = task;
        this.difficulty = difficulty;
        this.targetVowel = targetVowel;
        this.standardVowel = null;
        if (task == Task.discrimination) {
            if (new Random().nextBoolean()) {
                this.standardVowel = standardVowel;
            } else {
                this.targetVowel = standardVowel;
                this.standardVowel = targetVowel;
            }
        }
    }

    public Task getTask() {
        return task;
    }

    public Difficulty getDifficulty() {
        return difficulty;
    }

    public Vowel getTargetVowel() {
        return targetVowel;
    }

    public Vowel getStandardVowel() {
        return standardVowel;
    }

    public long getTargetId() {
        return targetVowel.getId();
    }

    public long getStandardId() {
        if (standardVowel != null) {
            return standardVowel.getId();
        } else {
            return -1;
        }
    }

    public void lowerDifficulty() {
        if (difficulty == Difficulty.veryhard) {
            difficulty = Difficulty.hard;
        } else if (difficulty == Difficulty.hard) {
            difficulty = Difficulty.medium;
        } else if (difficulty == Difficulty.medium) {
            difficulty = Difficulty.easy;
        }
    }

}
