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
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

/**
 * @since Apr 16, 2015 3:25:40 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class Settings {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    enum Difficulty {

        // while this might be stored for the user, the mobile app will probably send this data on each request even if it overrides the stored values
        easy(false, false), medium(true, false), hard(false, true), veryhard(true, true);
        final boolean allowMultipleSpeaker;
        final boolean allowMultipleStartConsonant;

        Difficulty(boolean allowMultipleSpeaker, boolean allowMultipleStartConsonant) {
            this.allowMultipleSpeaker = allowMultipleSpeaker;
            this.allowMultipleStartConsonant = allowMultipleStartConsonant;
        }
    }
    Difficulty difficulty;
    @OneToMany
    // todo: determine if this is required
    private ArrayList<Speaker> excludedSpeakers;
    @OneToMany
    // todo: determine if this is required
    private ArrayList<Word> excludedWords;
    @OneToMany
    // todo: determine if this is required
    private ArrayList<Consonant> excludedConsonants;
    @OneToMany
    // todo: determine if this is required
    private ArrayList<Vowel> excludedVowels;
    @OneToOne
    // todo: determine if this is required
    private Task usersPreferedTask;
}
