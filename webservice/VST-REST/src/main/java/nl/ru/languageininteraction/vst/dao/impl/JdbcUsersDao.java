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
package nl.ru.languageininteraction.vst.dao.impl;

import java.util.List;
import java.util.UUID;
import nl.ru.languageininteraction.vst.dao.UsersDao;
import nl.ru.languageininteraction.vst.model.UserData;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @since Mar 27, 2015 1:35:38 PM (creation date)
 * @author Peter Withers <p.withers@psych.ru.nl>
 */
//@Component
//@Resource
//@EJB
//@Resource(name="usersDao")
//@Stateless
//@LocalBean
//@ManagedBean
public class JdbcUsersDao /* extends NamedParameterJdbcDaoSupport */ implements UsersDao {

    private final Logger logger = LoggerFactory.getLogger(JdbcUsersDao.class);
//    @Resource(name = "jdbc/VowelSpaceTravel")
//    private javax.sql.DataSource vstDB;

    //    @Autowired
    //    public void setDs(DataSource dataSource) {
    //        setDataSource(dataSource);
    //    }

    @Override
    public int getUserCount() {
        return 5;
    }

    @Override
    public List<UserData> getUsers() {
        //        StringBuilder sql = new StringBuilder("SELECT ");
        //        sql.append("user_id").append(",").append("last_modified").append(",").append("user_name").append(" FROM ").append("vst_user");
        //        return getNamedParameterJdbcTemplate().queryForObject(sql.toString());
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public UserData getUserDetails(UUID uuid) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public UserData createUser() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
