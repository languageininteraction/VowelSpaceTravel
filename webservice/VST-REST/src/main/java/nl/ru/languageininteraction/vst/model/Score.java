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

import java.util.Random;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import nl.ru.languageininteraction.vst.rest.ConfidenceRepository;

/**
 * @since Sep 16, 2015 2:35:45 PM (creation date)
 * @author Karen Dijkstra <k.dijkstra@donders.ru.nl>
 */
@Entity
public class Score {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;
    
    @ManyToOne
    private Player player;
    private Double score;
    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;

    public Score() {
    }
    
    public Score(ConfidenceRepository confidenceRepository,Player player, Vowel targetVowel, Vowel standardVowel)
    {
        this.player = player;
        score = new Random().nextDouble();
        this.standardVowel = standardVowel;
        this.targetVowel = targetVowel;
        
        // TODO: add code to calculate score from confidence values.
    }

    public Player getPlayer() {
        return player;
    }

    public Double getScore() {
        return score;
    }

    public Vowel getTargetVowel() {
        return targetVowel;
    }

    public Vowel getStandardVowel() {
        return standardVowel;
    }
   
    
    
}
