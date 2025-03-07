/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.aw3.bg.configuration;

import javax.sql.DataSource;

import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

//ref https/www.baseldung.com/spring-boot-configure-multiple-datasources
//測試環境 @AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) 不會自動將 multi dataSource bean 載入
//會引發 DataSourceConfiguration 之 static class Hikari 會認為沒有 dataSource bean 而走入建構的程序引發如下錯誤
//Caused by: org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
//以利 unit test 可以手動 @Import(AwBGLportalDataSourceConfiguration.class)
@Configuration
public class AwBGLportalDataSourceConfiguration {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start
    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    // 當有多個datasource 時，需要自行宣告綁定主 datasource 並宣告 @Primary，以利主 jpa 建構 LocalContainerEntityManagerFactoryBean 綁定預期的主 datasource
    // 否則 LocalContainerEntityManagerFactoryBean 參考 datasource 會出現如下錯誤
    // Caused by: org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'javax.sql.DataSource' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {@org.springframework.beans.factory.annotation.Autowired(required=true), @org.springframework.beans.factory.annotation.Qualifier(value=lportalDataSource)}
    @Primary // 當 autowired 該 bean 未宣告 alias 代表使用宣告 @Primary 的 bean
    @Bean
    @ConfigurationProperties("spring.datasource")
    DataSourceProperties lportalDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Primary // 當 autowired 該 bean 未宣告 alias 代表使用宣告 @Primary 的 bean
    @Bean
    @ConfigurationProperties("spring.datasource.hikari") // 置入對應 connection pool
    DataSource lportalDataSource(final DataSourceProperties lportalDataSourceProperties) { // 使用 dataSource 確保不走到 DataSourceConfiguration.Hikari 配置
        return lportalDataSourceProperties.initializeDataSourceBuilder().build();
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
