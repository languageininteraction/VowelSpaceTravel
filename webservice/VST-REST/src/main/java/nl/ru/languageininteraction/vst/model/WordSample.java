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
 * @since Mar 20, 2015 5:00:43 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class WordSample {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    @ManyToOne
    private Speaker spokenBy;
    @ManyToOne
    Word word;
    private String soundFilePath;
    private long vowelId;

    public WordSample(Speaker spokenBy, Word word, String soundFilePath) {
        if (word == null) {
            throw new UnsupportedOperationException(soundFilePath);
        }
        this.spokenBy = spokenBy;
        this.word = word;
        this.soundFilePath = soundFilePath;
        this.vowelId = word.getVowel().getId();
    }

    public WordSample() {
    }

    public long getId() {
        return id;
    }

    public Speaker getSpokenBy() {
        return spokenBy;
    }

    public Word getWord() {
        return word;
    }

    public long getVowelId() {
        return vowelId;
    }

    public String getSoundFilePath() {
        return soundFilePath;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 17 * hash + (int) (this.id ^ (this.id >>> 32));
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
        final WordSample other = (WordSample) obj;
        if (this.id != other.id) {
            return false;
        }
        return true;
    }
}
