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
public class StimulusResult {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    @ManyToOne
    private Player player;
    
    @ManyToOne
    private Word word;
    long responceTimeMs;

    public StimulusResult(Player player, Word word, long responceTimeMs) {
        this.player = player;
        this.word = word;
        this.responceTimeMs = responceTimeMs;
    }

    public StimulusResult() {
    }

    public long getId() {
        return id;
    }

    public Player getPlayer() {
        return player;
    }

    public Word getWord() {
        return word;
    }

    public long getResponceTimeMs() {
        return responceTimeMs;
    }
    
}
