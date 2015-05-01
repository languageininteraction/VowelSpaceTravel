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
import org.springframework.hateoas.ResourceSupport;

/**
 * @since Apr 23, 2015 11:05:44 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class Stimulus extends ResourceSupport {

    public enum Relevance {

        isTarget, isStandard, isIrelevant
    };
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    @ManyToOne
    private Player player;
    @ManyToOne
    private WordSample wordSample;
    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;
    private Relevance relevance;
    private Boolean playerResponse = null;

    public Stimulus(Player player, WordSample wordSample, Relevance relevance) {
        this.player = player;
        this.wordSample = wordSample;
    }

    public Stimulus() {
    }

    public String getSpeakerLabel() {
        if (wordSample.getSpokenBy() != null) {
            return wordSample.getSpokenBy().getLabel();
        } else {
            return null;
        }
    }

    public String getWordString() {
        if (wordSample.getWord() != null) {
            return wordSample.getWord().getWordString();
        } else {
            return null;
        }
    }

    public Long getSampleId() {
        if (wordSample != null) {
            return wordSample.getId();
        } else {
            return null;
        }
    }

    public Relevance getRelevance() {
        return relevance;
    }  

    public Boolean isPlayerResponse() {
        return playerResponse;
    }

    public void setPlayerResponse(boolean playerResponse) {
        this.playerResponse = playerResponse;
    }
}
