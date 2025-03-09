/*
 * Copyright © 2011 M.O.I. All rights reserved
 */
package tw.gov.moi.aw3.info.liferay.configuration;

import java.util.Locale;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;

/**
 * 示範使用url 解析 locale 決定國際化訊息的方式
 * 會使用到攔截器是因為確保是到最後面的後端才攔截避免前端解析非預期，如有使用 apache tiles ，若使用 LocaleResolver 解析request會有連其父類別模板路徑也被解析到的問題
 **/
@Configuration
public class InfoLiferayI18nConfiguration {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start
    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start
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

    @Bean
    LocaleResolver localeResolver() {
        final CookieLocaleResolver resolver = new CookieLocaleResolver();
        resolver.setDefaultLocale(Locale.TAIWAN);
        resolver.setCookieName("myLocaleCookie");
        resolver.setCookieMaxAge(4800);
        return resolver;
    }

    @Bean
    LocalePathInterceptor localePathInterceptor() {
        return new LocalePathInterceptor();
    }

    @Configuration(proxyBeanMethods = false)
    static class i18Interceptors implements WebMvcConfigurer {

        private LocalePathInterceptor localePathInterceptor;

        public i18Interceptors(final LocalePathInterceptor localePathInterceptor) {
            this.localePathInterceptor = localePathInterceptor;
        }

        @Override
        public void addInterceptors(final InterceptorRegistry registry) {

            registry.addInterceptor(this.localePathInterceptor).addPathPatterns("/app/en/suggestmail/**", "/app/suggestmail/**");
        }

    }

    //== [Method] Block Stop
    //================================================
    //== [Inner Class] Block Start
    //== [Inner Class] Block Stop
    //================================================
}
