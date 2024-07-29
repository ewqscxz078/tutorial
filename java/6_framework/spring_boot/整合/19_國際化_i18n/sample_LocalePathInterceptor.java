import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;

/**
 *
 */
public class LocalePathInterceptor implements HandlerInterceptor {

    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start

    private static final Logger LOGGER = LoggerFactory.getLogger(LocalePathInterceptor.class);

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

    @Override
    public boolean preHandle(final HttpServletRequest request, final HttpServletResponse response,
            final Object handler) throws Exception {
        final String uri = request.getRequestURI();
        final String contextPath = request.getContextPath();
        final String pathWithoutContext = uri.substring(contextPath.length());

        LOGGER.debug("LocalePathInterceptor:pathWithoutContext : {}", pathWithoutContext);

        Locale locale;
        if (pathWithoutContext.startsWith("/app/en")) {
            locale = Locale.ENGLISH;
        } else if (pathWithoutContext.startsWith("/app")) {
            locale = Locale.TAIWAN;
        } else {
            locale = Locale.TAIWAN;
        }

        // 1.透過攔截器分析 url 應為何語系後，將其塞入到 request 屬性後，
        // 2.再透過 CookieLocaleResolver.resolveLocale(){ 裡的 request.getAttribute(LOCALE_REQUEST_ATTRIBUTE_NAME) } 取得其語系
        // 3.以利後續 jsp tag spring:message 之 MessageTag 的 protected String resolveMessage() throws JspException, NoSuchMessageException {
        //   ....
        //   return messageSource.getMessage( this.code, argumentsArray, getRequestContext().getLocale());
        //   ....
        // }
        //request.getSession().setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale);
        request.setAttribute(CookieLocaleResolver.LOCALE_REQUEST_ATTRIBUTE_NAME, locale);

        LOGGER.debug("locale : {}", locale.toString());
        return true;
    }

    //== [Method] Block Stop
    //================================================
    //== [Inner Class] Block Start
    //== [Inner Class] Block Stop
    //================================================
}
