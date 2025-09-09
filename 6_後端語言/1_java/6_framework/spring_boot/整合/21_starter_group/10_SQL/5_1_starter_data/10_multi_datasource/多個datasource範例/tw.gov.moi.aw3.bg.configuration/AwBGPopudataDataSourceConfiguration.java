/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.aw3.bg.configuration;

import javax.sql.DataSource;

import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

//ref https/www.baseldung.com/spring-boot-configure-multiple-datasources
//測試環境 @AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) 不會自動將 multi dataSource bean 載入
//會引發 DataSourceConfiguration 之 static class Hikari 會認為沒有 dataSource bean 而走入建構的程序引發如下錯誤
//Caused by: org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
//以利 unit test 可以手動 @Import(AwBGPopudataDataSourceConfiguration.class)
@Configuration
public class AwBGPopudataDataSourceConfiguration {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start
    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    @Bean(name = "popudataDataSourceProperties")
    @ConfigurationProperties("spring.datasource.popudata")
    DataSourceProperties popudataDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Bean(name = "popudataDataSource")
    @ConfigurationProperties("spring.datasource.popudata.hikari") // 置入對應 connection pool
    DataSource popudataDataSource(final DataSourceProperties popudataDataSourceProperties) {
        return popudataDataSourceProperties.initializeDataSourceBuilder().build();
    }

    //== [Instance Variables] Block Stop
    //================================================
    //== [Static Constructor] Block Start
    //== [Static Constructor] Block Stop
    //================================================
    //== [Constructors] Block Start (含init method)
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
