package com.pii.java_service.controller;

import com.pii.java_service.model.ValidationResults;
import com.pii.java_service.service.SsnEncryptionService;
import com.pii.java_service.service.SsnValidationService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(SsnController.class)
class SsnControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SsnValidationService ssnValidationService;

    @MockBean
    private SsnEncryptionService ssnEncryptionService;

    @BeforeEach
    void setUp() {
    }

    @Test
    @DisplayName("Should validate SSN via POST /api/ssn/validate")
    void testValidateSsnEndpoint() throws Exception {   
        when(ssnValidationService.validate(anyString())).thenReturn(new ValidationResults(true));
        mockMvc.perform(post("/api/ssn/validate")
                .contentType(MediaType.TEXT_PLAIN)
                .content("123-45-6789"))
                .andExpect(status().isOk())
                .andExpect(content().json("{\"valid\":true}"));
    }

    @Test
    @DisplayName("Should encrypt SSN via POST /api/ssn/encrypt")
    void testEncryptSsnEndpoint() throws Exception {
        when(ssnEncryptionService.encrypt(anyString())).thenReturn("encrypted123");
        mockMvc.perform(post("/api/ssn/encrypt")
                .contentType(MediaType.TEXT_PLAIN)
                .content("123-45-6789"))
                .andExpect(status().isOk())
                .andExpect(content().string("encrypted123"));
    }

    @Test
    @DisplayName("Should decrypt SSN via POST /api/ssn/decrypt")
    void testDecryptSsnEndpoint() throws Exception {    
        when(ssnEncryptionService.decrypt(anyString())).thenReturn("123-45-6789");
        mockMvc.perform(post("/api/ssn/decrypt")
                .contentType(MediaType.TEXT_PLAIN)
                .content("encrypted123"))
                .andExpect(status().isOk())
                .andExpect(content().string("123-45-6789"));
    }

    @Test
    @DisplayName("Should return 500 for service errors")
    void testServiceErrorHandling() throws Exception {
        when(ssnValidationService.validate(anyString())).thenThrow(new RuntimeException("Service error"));
        mockMvc.perform(post("/api/ssn/validate")
                .contentType(MediaType.TEXT_PLAIN)
                .content("123-45-6789"))
                .andExpect(status().is5xxServerError());
    }
}

