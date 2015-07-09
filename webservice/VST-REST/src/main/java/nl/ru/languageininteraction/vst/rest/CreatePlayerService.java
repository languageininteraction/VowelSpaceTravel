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
package nl.ru.languageininteraction.vst.rest;

import nl.ru.languageininteraction.vst.model.Player;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * @since Jul 1, 2015 3:44:52 PM (creation date)
 * @author Peter Withers <peter.withers@mpi.nl>
 */
@RestController
public class CreatePlayerService {

    @Autowired
    private PlayerRepository participantRepository;

    @RequestMapping(value = "/createuser", method = RequestMethod.POST)
    public String createuser(@RequestBody Player player) {

        if (player.getEmail() == null || player.getEmail().isEmpty()) {
            throw new IllegalArgumentException("The 'email' parameter is required");
        }
        if (player.getToken() == null || player.getToken().isEmpty()) {
            throw new IllegalArgumentException("The 'token' parameter is required");
        }

        participantRepository.save(player);
        return "Created: " + player.getEmail();
    }
}
