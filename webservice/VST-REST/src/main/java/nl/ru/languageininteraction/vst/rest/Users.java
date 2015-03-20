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

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import nl.ru.languageininteraction.vst.model.UserData;

/**
 * @since Mar 20, 2015 11:54:04 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Path("users")
public class Users {

    private static final Logger logger = Logger.getLogger(Users.class.getName());

    @GET
    @Produces(MediaType.APPLICATION_XML)
    @Path("list")
    public List<UserData> getList() {
        logger.info("getList");
        final ArrayList<UserData> returnList = new ArrayList<>();
        returnList.add(new UserData());
        returnList.add(new UserData());
        returnList.add(new UserData());
        returnList.add(new UserData());
        returnList.add(new UserData());
        returnList.add(new UserData());
        returnList.add(new UserData());
        returnList.add(new UserData());
        returnList.add(new UserData());
        return returnList;
    }

    @GET
    @Produces(MediaType.APPLICATION_XML)
    @Path("create")
    public UserData createUser() {
        logger.info("createUser");
        return new UserData();
    }

    @GET
    @Produces(MediaType.APPLICATION_XML)
    @Path("details")
    public UserData getUserDetails() {
        logger.info("getUserDetails");
        return new UserData();
    }
}
