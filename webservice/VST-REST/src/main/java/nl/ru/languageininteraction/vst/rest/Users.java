/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
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
