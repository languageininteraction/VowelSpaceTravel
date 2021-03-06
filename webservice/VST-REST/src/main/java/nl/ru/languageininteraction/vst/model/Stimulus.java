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

import java.util.Date;
import java.util.Objects;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Temporal;
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
    private long responseTimeMs;
    @Temporal(javax.persistence.TemporalType.TIMESTAMP)
    private Date responseDate = null;
    @ManyToOne
    private WordSample wordSample;
    private Relevance relevance;
    private Boolean playerResponse = null;
    private long vowelId;

    public Stimulus(WordSample wordSample, Relevance relevance) {
        if (wordSample == null) {
            throw new UnsupportedOperationException("wordSample is null");
        }
        this.wordSample = wordSample;
        this.relevance = relevance;
        this.vowelId = wordSample.getWord().getVowel().getId();
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

    public WordSample getWordSample() {
        return wordSample;
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

    public Boolean getPlayerResponse() {
        return playerResponse;
    }

    public void setPlayerResponse(boolean playerResponse) {
        this.playerResponse = playerResponse;
    }

    public long getResponseTimeMs() {
        return responseTimeMs;
    }

    public void setResponseTimeMs(long responseTimeMs) {
        this.responseTimeMs = responseTimeMs;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
    }

    public long getVowelId() {
        return vowelId;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        hash = 23 * hash + Objects.hashCode(this.wordSample);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Stimulus other = (Stimulus) obj;
        if (!Objects.equals(this.wordSample, other.wordSample)) {
            return false;
        }
        return true;
    }
}
