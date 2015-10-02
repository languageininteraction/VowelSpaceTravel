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

/**
 * @since Sep 28, 2015 11:32:06 AM (creation date)
 * @author Karen Dijkstra <k.dijkstra@donders.ru.nl>
 */
public class VowelPair {

        private final Vowel vowelA;
        private final Vowel vowelB;

        public VowelPair(Vowel vowel1, Vowel vowel2) {
            if (new Random().nextDouble() <= 0.5){
                this.vowelA = vowel1;
                this.vowelB = vowel2;
            }
            else{
                this.vowelA = vowel2;
                this.vowelB = vowel1;
            }
        }

        @Override
        public boolean equals(Object obj) {
            if (obj == this) {
                return true;
            }
            if (obj == null || obj.getClass() != this.getClass()) {
                return false;
            }

            VowelPair vowelPair = (VowelPair) obj;

            return vowelPair.vowelA == this.vowelA && vowelPair.vowelB == this.vowelB
                    || vowelPair.vowelB == this.vowelA && vowelPair.vowelA == this.vowelB;
        }

    public Vowel getVowelA() {
        return vowelA;
    }

    public Vowel getVowelB() {
        return vowelB;
    }

}
