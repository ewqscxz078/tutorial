/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.aw3.bg.db.popudata.dao;

import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.context.annotation.Import;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import tw.gov.moi.aw3.bg.configuration.AwBGPopudataDataSourceConfiguration;
import tw.gov.moi.aw3.bg.db.popudata.model.PopuctrlAcc;

//@Disabled // 因為沒有使用 mock db，要測試時再開啟
@ActiveProfiles(profiles = "test")
@DataJpaTest // 預設不管怎樣都會 rollback
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) // 改成真的存取資料庫
@DisplayName("PopuctrlAccDAOTest jpa sql 驗證確認")
//測試環境 @AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE) 不會自動將 dataSource bean 載入
//會引發 DataSourceConfiguration 之 static class Hikari 會認為沒有 dataSource bean 而走入建構的程序引發如下錯誤
//java.lang.IllegalStateException: Failed to load ApplicationContext
//Caused by: org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'dataSourceScriptDatabaseInitializer' defined in class path resource [org/springframework/boot/autoconfigure/sql/init/DataSourceInitializationConfiguration.class]: Unsatisfied dependency expressed through method 'dataSourceScriptDatabaseInitializer' parameter 0; nested exception is org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'dataSource' defined in class path resource [org/springframework/boot/autoconfigure/jdbc/DataSourceConfiguration$Hikari.class]: Bean instantiation via factory method failed; nested exception is org.springframework.beans.BeanInstantiationException: Failed to instantiate [com.zaxxer.hikari.HikariDataSource]: Factory method 'dataSource' threw exception; nested exception is org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
//Caused by: org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'dataSource' defined in class path resource [org/springframework/boot/autoconfigure/jdbc/DataSourceConfiguration$Hikari.class]: Bean instantiation via factory method failed; nested exception is org.springframework.beans.BeanInstantiationException: Failed to instantiate [com.zaxxer.hikari.HikariDataSource]: Factory method 'dataSource' threw exception; nested exception is org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
//Caused by: org.springframework.beans.BeanInstantiationException: Failed to instantiate [com.zaxxer.hikari.HikariDataSource]: Factory method 'dataSource' threw exception; nested exception is org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
//Caused by: org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
@Import(AwBGPopudataDataSourceConfiguration.class)
@Rollback(false)
public class PopuctrlAccDAOTest {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start

    private static final Logger LOGGER = LoggerFactory.getLogger(PopuctrlAccDAOTest.class);

    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    @Autowired
    private PopuctrlAccDAO popuctrlAccDAO;

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

    @Test
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    public void test_crud() {

        // before check
        final long count = this.popuctrlAccDAO.count();
        assertTrue(count > 0);

        // select not exist id
        final PopuctrlAcc byId = this.popuctrlAccDAO.findById(666666l).orElse(null);
        assertNull(byId);

        // create id
        final PopuctrlAcc popuctrlAcc = new PopuctrlAcc();
        popuctrlAcc.setSerialCode(666666l);
        popuctrlAcc.setUserid("unittest");
        final PopuctrlAcc po = this.popuctrlAccDAO.save(popuctrlAcc);

        // update id
        po.setUsername("updateName");
        this.popuctrlAccDAO.save(po);

        // delete id
        this.popuctrlAccDAO.delete(po);

        // after check
        final long afterCheckCount = this.popuctrlAccDAO.count();
        assertTrue(afterCheckCount > 0);
    }

    //== [Method] Block Stop
    //================================================
    //== [Inner Class] Block Start
    //== [Inner Class] Block Stop
    //================================================
}
