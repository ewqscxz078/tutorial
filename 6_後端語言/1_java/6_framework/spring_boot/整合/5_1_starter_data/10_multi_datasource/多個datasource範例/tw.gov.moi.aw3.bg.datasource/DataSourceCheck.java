/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.aw3.bg.datasource;

import java.sql.Connection;
import java.sql.SQLException;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.zaxxer.hikari.HikariDataSource;

@Component
public class DataSourceCheck {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start

    private static final org.slf4j.Logger LOGGER = org.slf4j.LoggerFactory.getLogger(DataSourceCheck.class);

    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    @Autowired
    @Qualifier("lportalDataSource")
    private DataSource lportalDataSource;// dataSource;

    @Autowired
    @Qualifier("popudataDataSource")
    private DataSource popudataDataSource;

    //== [Instance Variables] Block Stop
    //================================================
    //== [Static Constructor] Block Start
    //== [Static Constructor] Block Stop
    //================================================
    //== [Constructors] Block Start (含init method)

    @PostConstruct
    public void checkDatasource() throws SQLException {
        LOGGER.debug("lportalDataSource : {}", this.lportalDataSource);
        LOGGER.debug("popudataDataSource : {}", this.popudataDataSource);

        if (this.lportalDataSource instanceof HikariDataSource) {
            LOGGER.debug("lportalDataSource of HikariDataSource : {}", ((HikariDataSource) this.lportalDataSource).getPoolName());
        }
        if (this.popudataDataSource instanceof HikariDataSource) {
            LOGGER.debug("popudataDataSource of HikariDataSource : {}",
                    ((HikariDataSource) this.popudataDataSource).getPoolName());
        }

        try (Connection conn1 = this.lportalDataSource.getConnection(); //
                Connection conn2 = this.popudataDataSource.getConnection();) {

        }

    }

    //== [Constructors] Block Stop
    //================================================
    //== [Static Method] Block Start
    //== [Static Method] Block Stop
    //================================================
    //== [Accessor] Block Start
    //== [Accessor] Block Stop
    //================================================
    //== [Overrided JDK Method] Block Start (Ex. toString / equals+hashCode)
    //== [Overrided JDK Method] Block Stop
    //================================================
    //== [Method] Block Start
    //####################################################################
    //## [Method] sub-block :
    //####################################################################
    //== [Method] Block Stop
    //================================================
    //== [Inner Class] Block Start
    //== [Inner Class] Block Stop
    //================================================
}
