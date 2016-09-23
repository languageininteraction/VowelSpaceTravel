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

import java.security.Principal;
import nl.ru.languageininteraction.vst.model.Player;
import nl.ru.languageininteraction.vst.model.TaskSuggestion;
import static org.springframework.hateoas.mvc.ControllerLinkBuilder.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.Resource;
import org.springframework.hateoas.Resources;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import org.springframework.web.bind.annotation.ResponseBody;
/**
 * @since Jun 3, 2016 3:53:40 PM (creation date)
 * @author Karen Dijkstra <k.dijkstra@donders.ru.nl>
 */
@Controller
@RequestMapping(value = "/player", produces = "application/json")
public class PlayerController {
    
    @Autowired
    PlayerRepository playerRepository;

    @RequestMapping(value = "/info", method = GET)
    @ResponseBody
    public ResponseEntity<Resource<Player>> getPlayer(Principal principal) {
        Player player = playerRepository.findByEmail(principal.getName());
        Resource<Player> wrapped = new Resource<>(player, linkTo(PlayerController.class).withSelfRel());
        return new ResponseEntity<>(wrapped, HttpStatus.OK);
    }
    
    @RequestMapping(value = "/id", method = GET)
    @ResponseBody
    public ResponseEntity<Resource<Long>> getPlayerID(Principal principal) {
        Player player = playerRepository.findByEmail(principal.getName());
        Long playerID = player.getId();
        Resource<Long> wrapped = new Resource<>(playerID, linkTo(PlayerController.class).withSelfRel());
        return new ResponseEntity<>(wrapped, HttpStatus.OK);
    }
        
}
