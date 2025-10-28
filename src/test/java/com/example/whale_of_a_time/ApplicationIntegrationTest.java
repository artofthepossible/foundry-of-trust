package com.example.whale_of_a_time;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
public class ApplicationIntegrationTest {

    @LocalServerPort
    private int port;

    private final TestRestTemplate restTemplate = new TestRestTemplate();

    @Container
    static GenericContainer<?> redis = new GenericContainer<>(DockerImageName.parse("redis:alpine"))
            .withExposedPorts(6379);

    @Test
    void applicationStartsSuccessfully() {
        String response = restTemplate.getForObject("http://localhost:" + port + "/", String.class);
        
        assertThat(response).isNotNull();
        assertThat(response).contains("Welcome to My Spring Boot Application");
    }

    @Test
    void githubLinkIsPresent() {
        String response = restTemplate.getForObject("http://localhost:" + port + "/", String.class);
        
        assertThat(response).isNotNull();
        assertThat(response).contains("Get it on GitHub");
        assertThat(response).contains("https://github.com/artofthepossible/whale-of-a-time");
    }

    @Test
    void testcontainerIsWorking() {
        // Simple test to verify Testcontainers is working
        assertThat(redis.isRunning()).isTrue();
        assertThat(redis.getMappedPort(6379)).isGreaterThan(0);
    }
}