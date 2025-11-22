package com.pii.java_service.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

class SsnEncryptionServiceTest {

    private SsnEncryptionService ssnEncryptionService;

    @BeforeEach
    void setUp() {
        ssnEncryptionService = new SsnEncryptionService();
    }

    @Test
    @DisplayName("Should encrypt an SSN")
    void testEncryptSsn() {
        String ssn = "123-45-6789";
        String encrypted = ssnEncryptionService.encrypt(ssn);
        assertNotNull(encrypted);
        assertNotEquals(ssn, encrypted);
    }

    @Test
    @DisplayName("Should decrypt an encrypted SSN correctly")
    void testDecryptSsn() {
        String originalSsn = "123-45-6789";
        String encrypted = ssnEncryptionService.encrypt(originalSsn);
        String decrypted = ssnEncryptionService.decrypt(encrypted);
        assertEquals(originalSsn, decrypted);
    }

    @Test
    @DisplayName("Should produce different encrypted values for same SSN")
    void testEncryptionProducesDifferentValues() {
        String ssn = "123-45-6789";
        String encrypted1 = ssnEncryptionService.encrypt(ssn);
        String encrypted2 = ssnEncryptionService.encrypt(ssn);
        assertNotEquals(encrypted1, encrypted2);
    }

    @Test
    @DisplayName("Should handle null input gracefully")
    void testEncryptNullInput() {
        String ssn = null;
        assertThrows(RuntimeException.class, () -> ssnEncryptionService.encrypt(ssn));
    }

    @Test
    @DisplayName("Should handle empty string input gracefully")
    void testEncryptEmptyInput() {
        String ssn = "";
        String encrypted = ssnEncryptionService.encrypt(ssn);
        String decrypted = ssnEncryptionService.decrypt(encrypted);
        assertEquals(ssn, decrypted);
    }

    @Test
    @DisplayName("Should throw exception for invalid encrypted string")
    void testDecryptInvalidString() {   
        String encrypted = "invalid";
        assertThrows(RuntimeException.class, () -> ssnEncryptionService.decrypt(encrypted));
    }
}

