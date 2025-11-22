package com.pii.java_service.service;

import com.pii.java_service.model.ValidationResults;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

import static org.junit.jupiter.api.Assertions.*;

class SsnValidationServiceTest {

    private SsnValidationService ssnValidationSerivce;

    @BeforeEach
    void setUp() {
        ssnValidationSerivce = new SsnValidationService();
    }

    @Test
    @DisplayName("Should validate a valid SSN")
    void testValidateValidSsn() {
        String ssn = "123-45-6789";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertTrue(results.isValid());
    }

    @Test
    @DisplayName("Should reject null SSN")
    void testValidateNullSsn() {
        String ssn = null;
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("SSN cannot be null or empty", results.getErrorMessage());
    }

    @Test
    @DisplayName("Should reject empty SSN")
    void testValidateEmptySsn() {
        String ssn = "";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("SSN cannot be null or empty", results.getErrorMessage());
    }

    @Test
    @DisplayName("Should reject SSN with invalid format")
    void testValidateInvalidFormat() {
        String ssn = "123456789";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("SSN must be in the format XXX-XX-XXXX", results.getErrorMessage());
    }

    @Test
    @DisplayName("Should reject SSN with area number 000")
    void testValidateAreaNumber000() {
        String ssn = "000-45-6789";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("Area number cannot be 000 or 666", results.getErrorMessage());
    }

    @Test
    @DisplayName("Should reject SSN with area number 666")
    void testValidateAreaNumber666() {
        String ssn = "666-45-6789";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("Area number cannot be 000 or 666", results.getErrorMessage());
    }

    @Test
    @DisplayName("Should allow area number 900-999")
    void testValidateAreaNumber900to999() {
        String ssn = "900-45-6789";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertTrue(results.isValid());
    }

    @Test
    @DisplayName("Should reject SSN with group number 00")
    void testValidateGroupNumber00() {
        String ssn = "123-00-6789";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("Group number cannot be 00", results.getErrorMessage());
    }

    @Test
    @DisplayName("Should reject SSN with serial number 0000")
    void testValidateSerialNumber0000() {
        String ssn = "123-45-0000";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("Serial number cannot be 0000", results.getErrorMessage());
    }

    @Test
    @DisplayName("Should reject known invalid test SSN 078-05-1120")
    void testValidateKnownInvalidSsn() {
        String ssn = "078-05-1120";
        ValidationResults results = ssnValidationSerivce.validate(ssn);
        assertFalse(results.isValid());
        assertEquals("SSN is a known invalid test number", results.getErrorMessage());
    }
}

