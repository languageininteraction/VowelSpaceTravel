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

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * @since May 18, 2015 5:54:30 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
public class ConfidenceTest {

    public ConfidenceTest() {
    }

    /**
     * Test of getting confidence via the CRUD DB with inserted user results.
     */
    @org.junit.Test
    public void testViaCrudDb() {
        System.out.println("testViaCrudDb");
        // todo: add a unit test that inserts into the database and gets the confidence from the query results
        fail("The test case is a prototype.");
    }

    /**
     * Test of getLowerBound method, of class Confidence.
     */
    @Test
    public void testGetLowerBound() {
        System.out.println("getLowerBound");
        assertEquals(0.3315, new Confidence(8, 8, 8, 8).getLowerBound(), 0.01);
        assertEquals(0.1797, new Confidence(0, 8, 8, 8).getLowerBound(), 0.01);
    }

    /**
     * Test of getUpperBound method, of class Confidence.
     */
    @Test
    public void testGetUpperBound() {
        System.out.println("getUpperBound");
        assertEquals(0.66, new Confidence(8, 8, 8, 8).getUpperBound(), 0.01);
        assertEquals(0.5329, new Confidence(0, 8, 8, 8).getUpperBound(), 0.01);
    }
}
