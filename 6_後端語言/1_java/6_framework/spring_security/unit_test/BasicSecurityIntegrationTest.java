import static org.junit.jupiter.api.Assertions.assertEquals;

import java.net.MalformedURLException;
import java.net.URL;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.ActiveProfiles;

// ref https://www.baeldung.com/spring-boot-security-autoconfiguration
//若要執行整合測試則把註解的 @Disabled 解開即可
@Disabled
@ActiveProfiles(profiles = "test")
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@DisplayName("測試 spring security 受保護的 url")
public class BasicSecurityIntegrationTest {
    //================================================
    //== [Enumeration Types] Block Start
    //== [Enumeration Types] Block End
    //================================================
    //== [Static Variables] Block Start

    private static Logger LOGGER = LoggerFactory.getLogger(BasicSecurityIntegrationTest.class);

    //== [Static Variables] Block Stop
    //================================================
    //== [Instance Variables] Block Start

    TestRestTemplate restTemplate;

    URL base;

    @LocalServerPort
    int localPort;

    @Value("${ACTUATOR_USER:actuser}")
    private String actUser;

    @Value("${ACTUATOR_MIMA:actmima}")
    private String actMima;

    @Value("${server.servlet.context-path}")
    private String contextPath;

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

    //    @Autowired
    //    private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    //    @Test
    //    public void testEncode() {
    //        final String user = "actuser";
    //        final String mima = "xxxxx";
    //        final String encodeUser = this.passwordEncoder.encode(user);
    //        final String encodeMima = this.passwordEncoder.encode(mima);
    //
    //        LOGGER.debug("{} : {}", user, encodeUser);
    //        LOGGER.debug("{} : {}", mima, encodeMima);
    //    }

    @BeforeEach
    public void setUp() throws MalformedURLException {
        this.restTemplate = new TestRestTemplate(this.actUser, this.actMima);
        this.base = new URL("http://localhost:" + this.localPort + "/" + this.contextPath);
    }

    @DisplayName("測試 actuator 輸入受保護的帳密成功")
    @Test
    public void whenLoggedUserRequestActuator_ThenSuccess() {
        final ResponseEntity<String> response = this.restTemplate.getForEntity(this.base.toString() + "/actuator", String.class);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        LOGGER.debug("response.getBody : {}", response.getBody());
    }

    @DisplayName("測試 actuator 輸入受保護的帳密打錯")
    @Test
    public void whenUserWithWrongMimaRequestActuator_ThenFail() {
        this.restTemplate = new TestRestTemplate(this.actUser, "wrongMima");
        final ResponseEntity<String> response = this.restTemplate.getForEntity(this.base.toString() + "/actuator", String.class);
        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        LOGGER.debug("response.getBody : {}", response.getBody());
    }

    //== [Method] Block Stop
    //================================================
    //== [Inner Class] Block Start
    //== [Inner Class] Block Stop
    //================================================
}
