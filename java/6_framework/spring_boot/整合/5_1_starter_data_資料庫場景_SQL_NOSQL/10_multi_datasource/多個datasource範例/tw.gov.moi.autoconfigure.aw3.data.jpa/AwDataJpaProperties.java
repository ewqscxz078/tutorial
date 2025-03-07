/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.autoconfigure.aw3.data.jpa;

import org.springframework.boot.context.properties.ConfigurationProperties;

import tw.gov.moi.aw3.properties.AwPrefixConfigurationProperties;

@ConfigurationProperties(prefix = AwPrefixConfigurationProperties.DATA_JPA)
public class AwDataJpaProperties {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start
    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    private DefaultScan defaultScan;

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

    public DefaultScan getDefaultScan() {
        return this.defaultScan;
    }

    public void setDefaultScan(final DefaultScan defaultScan) {
        this.defaultScan = defaultScan;
    }

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

    static class DefaultScan {
        boolean enable;

        public boolean isEnable() {
            return this.enable;
        }

        public void setEnable(final boolean enable) {
            this.enable = enable;
        }

    }

    //== [Inner Class] Block Stop
    //================================================
}
