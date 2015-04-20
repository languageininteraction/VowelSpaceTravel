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
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

/**
 * @since Apr 8, 2015 11:25:42 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class Word {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private String wordString;
    @ManyToOne
    private Consonant initailConsonant;
    @ManyToMany
    private List<Vowel> vowel;
    @ManyToOne
    private Consonant finalConsonant;
    @OneToMany(mappedBy = "word")
    private List<WordSample> wordSamples;

    public Word(String wordString, Consonant initailConsonant, List<Vowel> vowel, Consonant finalConsonant) {
        this.wordString = wordString;
        this.initailConsonant = initailConsonant;
        this.vowel = vowel;
        this.finalConsonant = finalConsonant;
    }

    public Word() {
    }

    public String getWordString() {
        return wordString;
    }

    public Consonant getInitailConsonant() {
        return initailConsonant;
    }

    public List<Vowel> getVowel() {
        return vowel;
    }

    public Consonant getFinalConsonant() {
        return finalConsonant;
    }
}
