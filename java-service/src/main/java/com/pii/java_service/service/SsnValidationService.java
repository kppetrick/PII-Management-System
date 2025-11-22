package com.pii.java_service.service;

import com.pii.java_service.model.ValidationResults;
import org.springframework.stereotype.Service;

@Service
public class SsnValidationService {

    // SSA SSN Validation Rules (per coding challenge requirements):
    // - Must be 9 digits in XXX-XX-XXXX format
    // - Area number (first 3 digits) cannot be 000 or 666
    // -- Area number may allow 900-999
    // - Group number (middle 2 digits) cannot be 00
    // - Serial number (last 4 digits) cannot be 0000
    // - Must not be a known invalid test SSN (e.g., 078-05-1120)

    public ValidationResults validate(String ssn) {
        if (ssn == null || ssn.isEmpty()) {
            return new ValidationResults(false, "SSN cannot be null or empty");
        }
        
        if (!ssn.matches("\\d{3}-\\d{2}-\\d{4}")) {
            return new ValidationResults(false, "SSN must be in the format XXX-XX-XXXX");
        }
        
        String[] parts = parseSsn(ssn);
        String area = parts[0];
        String group = parts[1];
        String serial = parts[2];
        
        if (area.equals("000") || area.equals("666")) {
            return new ValidationResults(false, "Area number cannot be 000 or 666");
        }
        
        if (group.equals("00")) {
            return new ValidationResults(false, "Group number cannot be 00");
        }
        
        if (serial.equals("0000")) {
            return new ValidationResults(false, "Serial number cannot be 0000");
        }
        
        if (ssn.equals("078-05-1120")) {
            return new ValidationResults(false, "SSN is a known invalid test number");
        }
        
        return new ValidationResults(true);
    }

    private String[] parseSsn(String ssn) {
        return ssn.split("-");
    }
}

