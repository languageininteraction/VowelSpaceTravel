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

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

/**
 * @since Apr 8, 2015 11:23:48 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class StimulusResponse {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @ManyToOne
    private Player player;

    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;
    boolean true_positive;
    boolean false_positive;
    boolean true_negative;
    boolean false_negative;

    long responceTimeMs;

    public StimulusResponse(Player player, Vowel targetVowel, Vowel standardVowel, boolean true_positive, boolean false_positive, boolean true_negative, boolean false_negative, long responceTimeMs) {
        this.player = player;
        this.targetVowel = targetVowel;
        this.standardVowel = standardVowel;
        this.true_positive = true_positive;
        this.false_positive = false_positive;
        this.true_negative = true_negative;
        this.false_negative = false_negative;
        this.responceTimeMs = responceTimeMs;
    }

    public StimulusResponse() {
    }

    public Player getPlayer() {
        return player;
    }

    public String getTargetDisc() {
        if (targetVowel != null) {
            return targetVowel.getDisc();
        } else {
            return "";
        }
    }

    public String getStandardDisc() {
        if (standardVowel != null) {
            return standardVowel.getDisc();
        } else {
            return "";
        }
    }

    public boolean isTrue_positive() {
        return true_positive;
    }

    public boolean isFalse_positive() {
        return false_positive;
    }

    public boolean isTrue_negative() {
        return true_negative;
    }

    public boolean isFalse_negative() {
        return false_negative;
    }

    public long getResponceTimeMs() {
        return responceTimeMs;
    }

    public void setTargetVowel(Vowel targetVowel) {
        this.targetVowel = targetVowel;
    }

    public void setStandardVowel(Vowel standardVowel) {
        this.standardVowel = standardVowel;
    }
}
