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

import java.util.UUID;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 * @since Mar 20, 2015 5:08:24 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Entity
public class Vowel {

    public enum Place {

        front, near_front, central, near_back, back
    }

    public enum Roundness {

        unrounded, rounded
    }

    public enum Manner {

        close, near_close, close_mid, mid, open_mid, near_open, open
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    private UUID uuid = UUID.randomUUID();
    private String ipa;
    private String disc;
    private Place place;
    private Manner manner;
    private Roundness roundness;

    public Vowel(long id, String ipa, String disc, Place place, Manner manner, Roundness roundness) {
        this.id = id;
        this.ipa = ipa;
        this.disc = disc;
        this.place = place;
        this.manner = manner;
        this.roundness = roundness;
    }

    public Vowel() {
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public UUID getUuid() {
        return uuid;
    }

    public void setUuid(UUID uuid) {
        this.uuid = uuid;
    }

    public String getIpa() {
        return ipa;
    }

    public void setIpa(String ipa) {
        this.ipa = ipa;
    }

    public String getDisc() {
        return disc;
    }

    public void setDisc(String disc) {
        this.disc = disc;
    }

    public Place getPlace() {
        return place;
    }

    public void setPlace(Place place) {
        this.place = place;
    }

    public Manner getManner() {
        return manner;
    }

    public void setManner(Manner manner) {
        this.manner = manner;
    }

    public Roundness getRoundness() {
        return roundness;
    }

    public void setRoundness(Roundness roundness) {
        this.roundness = roundness;
    }
}
