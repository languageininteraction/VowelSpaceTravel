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
 * @since May 21, 2015 5:49:21 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class VowelQuality {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    public enum Place {

        front, near_front, central, near_back, back
    }

    public enum Roundness {

        unrounded, rounded
    }

    public enum Manner {

        close, near_close, close_mid, mid, open_mid, near_open, open
    }
    @ManyToOne
    private Vowel vowel;
    private Place place;
    private Manner manner;
    private Roundness roundness;

    public VowelQuality(Vowel vowel, Place place, Manner manner, Roundness roundness) {
        this.vowel = vowel;
        this.place = place;
        this.manner = manner;
        this.roundness = roundness;
    }

    public VowelQuality() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Vowel getVowel() {
        return vowel;
    }

    public Place getPlace() {
        return place;
    }

    public Manner getManner() {
        return manner;
    }

    public Roundness getRoundness() {
        return roundness;
    }
}
