/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.ru.languageininteraction.vst.rest;

import java.util.logging.Logger;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * @since Mar 20, 2015 11:54:04 AM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@Path("users")
public class Users {

    private static final Logger logger = Logger.getLogger(Users.class.getName());
    private static final String SAMPLE_JSON_RESPONSE = "[{\"users\":[\n"
            + "    {\"name\":\"John\", \"id\":\"1234\"}, \n"
            + "    {\"name\":\"Anna\", \"id\":\"1235\"},\n"
            + "    {\"name\":\"Tim\", \"id\":\"1236\"},\n"
            + "    {\"name\":\"Tom\", \"id\":\"1237\"},\n"
            + "    {\"name\":\"Bill the one with a very long name\", \"id\":\"1237\"}\n"
            + "]}]";

    @GET
    @Produces("text/plain")
    public String getSubmit() {
        logger.info("getSubmit");
        return SAMPLE_JSON_RESPONSE;
    }
}
