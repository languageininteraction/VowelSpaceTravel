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

import javax.persistence.ManyToOne;

/**
 * @since Apr 23, 2015 4:11:22 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class Confidence {
// this is the confidence that the application has in the users ability to distinguish a given vowel pair
    @ManyToOne
    private Vowel targetVowel;
    @ManyToOne
    private Vowel standardVowel;
    
    
    float value; // 0 to 1
    
}
