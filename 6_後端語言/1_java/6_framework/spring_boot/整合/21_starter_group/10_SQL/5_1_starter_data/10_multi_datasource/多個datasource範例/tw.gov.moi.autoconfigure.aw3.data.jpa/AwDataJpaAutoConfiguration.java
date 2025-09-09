/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.autoconfigure.aw3.data.jpa;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.autoconfigure.data.jpa.JpaRepositoriesAutoConfiguration;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

import tw.gov.moi.autoconfigure.aw3.security.AwSecurityAutoConfiguration;
import tw.gov.moi.aw3.data.jpa.repository.AwJpaCustomQuery;
import tw.gov.moi.aw3.data.jpa.repository.AwJpaSpecificationExecutor;

// ref spring-boot-actoconfigure / SecurityAutoConfiguration.java
@AutoConfiguration(before = { //
        JpaRepositoriesAutoConfiguration.class, //
        AwSecurityAutoConfiguration.class //
})
@ConditionalOnClass(value = { AwJpaCustomQuery.class, AwJpaSpecificationExecutor.class })
public class AwDataJpaAutoConfiguration {

    /**
     * 僅適合單一 datasource 的預設 jpa 掃描
     */
    @ConditionalOnProperty(name = "aw3.data.jpa.default-scan.enable", havingValue = "true", matchIfMissing = true) // 未設定就代表 enable = true
    //for jpa spring bean pattern
    //sris3-awkitx-data-jpa-commons   / tw.gov.moi.aw3.commons.db.dao / ServiceParameterDAO
    //sris3-awkitx-security           / tw.gov.moi.aw3.security.db.dao / AwdfSystemMenuDAO、AwdfSystemRolePermissionDAO
    //sris3-aw-xxxx-boot-web          / tw.gov.moi.aw3.xxxx.db.dao    / yyyyDAO
    @EnableJpaRepositories(basePackages = "tw.gov.moi.aw3.**.db.dao")
    //for jpa entity 同上對應路徑
    @EntityScan(basePackages = "tw.gov.moi.aw3.**.db.model")
    @Configuration(proxyBeanMethods = false)
    static class DefaultScanConfiguration {

    }
}