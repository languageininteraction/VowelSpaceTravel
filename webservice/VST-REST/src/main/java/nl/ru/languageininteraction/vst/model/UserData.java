/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.ru.languageininteraction.vst.model;

import java.util.UUID;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @since Mar 20, 2015 3:27:56 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
@XmlRootElement(name = "userdata")
public class UserData {

    @XmlAttribute(name = "uuid")
    private UUID uuid = UUID.randomUUID();
    @XmlAttribute(name = "name")
    private String name = "bla";
}
