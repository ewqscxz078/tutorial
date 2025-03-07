/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.aw3.bg.configuration;

import java.util.Objects;

import javax.sql.DataSource;

import org.springframework.boot.orm.jpa.EntityManagerFactoryBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

//import com.zaxxer.hikari.HikariDataSource;

//ref https/www.baseldung.com/spring-boot-configure-multiple-datasources
@Configuration
@EnableTransactionManagement
@EnableJpaRepositories( //
        basePackages = { "tw.gov.moi.aw3.**.db.lportal.dao", // 當前專案掃描
                "tw.gov.moi.aw3.**.db.dao" }, // 為了兼容通用 sris3-awkitx-data-jpa-commons、sris3-awkitx-data-jpa-certification
        entityManagerFactoryRef = "lportalEntityManagerFactory", //
        transactionManagerRef = "lportalTransactionManager" //
)
public class AwBGLportalDataJpaConfiguration {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start
    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    @Primary // 當 autowired 該 bean 未宣告 alias 代表使用宣告 @Primary 的 bean
    @Bean
    LocalContainerEntityManagerFactoryBean lportalEntityManagerFactory( //
            final DataSource dataSource, // lportalDataSource
            final EntityManagerFactoryBuilder builder) {
        return builder.dataSource(dataSource) //
                .packages("tw.gov.moi.aw3.**.db.model") // entity scan
                .persistenceUnit("lportal") // 有多個 EntityManagerFactory 則需要設定以利區別
                .build();
    }

    @Primary // 當 autowired 該 bean 未宣告 alias 代表使用宣告 @Primary 的 bean
    @Bean
    PlatformTransactionManager lportalTransactionManager(
            final LocalContainerEntityManagerFactoryBean lportalEntityManagerFactory) {
        return new JpaTransactionManager(Objects.requireNonNull(lportalEntityManagerFactory.getObject()));
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
