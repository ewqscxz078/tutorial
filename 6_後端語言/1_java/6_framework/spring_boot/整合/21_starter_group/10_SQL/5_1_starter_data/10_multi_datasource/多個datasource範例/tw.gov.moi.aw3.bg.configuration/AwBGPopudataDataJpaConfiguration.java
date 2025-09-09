/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.aw3.bg.configuration;

import java.util.Objects;

import javax.sql.DataSource;

import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

//ref https/www.baseldung.com/spring-boot-configure-multiple-datasources
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories( //
        basePackages = "tw.gov.moi.aw3.**.db.popudata.dao", //
        entityManagerFactoryRef = "popudataEntityManagerFactory", //
        transactionManagerRef = "popudataTransactionManager" //
)
public class AwBGPopudataDataJpaConfiguration {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start
    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    @Bean(name = "popudataEntityManagerFactory")
    LocalContainerEntityManagerFactoryBean popudataEntityManagerFactory( //
            final DataSource popudataDataSource, //
            final EntityManagerFactoryBuilder builder) {
        return builder.dataSource(popudataDataSource) //
                .packages("tw.gov.moi.aw3.**.db.popudata.model") //
                .persistenceUnit("popudata") // 有多個 EntityManagerFactory 則需要設定以利區別
                .build();
    }

    @Bean(name = "popudataTransactionManager")
    PlatformTransactionManager popudataTransactionManager( //
            final LocalContainerEntityManagerFactoryBean popudataEntityManagerFactory) {
        return new JpaTransactionManager(Objects.requireNonNull(popudataEntityManagerFactory.getObject()));
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
