package com.pii.java_service.controller;

import com.pii.java_service.model.ValidationResults;
import com.pii.java_service.service.SsnEncryptionService;
import com.pii.java_service.service.SsnValidationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ssn")
public class SsnController {

    @Autowired
    private SsnValidationService validationService;

    @Autowired
    private SsnEncryptionService encryptionService;

    @PostMapping("/validate")
    public ResponseEntity<ValidationResults> validateSsn(@RequestBody String ssn) {
        ValidationResults results = validationService.validate(ssn);
        return ResponseEntity.ok(results);
    }

    @PostMapping("/encrypt")
    public ResponseEntity<String> encryptSsn(@RequestBody String ssn) {
        String encrypted = encryptionService.encrypt(ssn);
        return ResponseEntity.ok(encrypted);
    }

    @PostMapping("/decrypt")
    public ResponseEntity<String> decryptSsn(@RequestBody String encryptedSsn) {
        String decrypted = encryptionService.decrypt(encryptedSsn);
        return ResponseEntity.ok(decrypted);
    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<String> handleError(RuntimeException e) {
        return ResponseEntity.status(500).body(e.getMessage());
    }
}

