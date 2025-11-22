package com.pii.java_service.service;

import org.springframework.stereotype.Service;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

@Service
public class SsnEncryptionService {

    // SSN Encryption Requirements (per coding challenge):
    // - At Rest: Encrypt SSN in PostgreSQL using AES-256
    // - Java Service: Handle encryption/decryption operations

    private byte[] getEncryptionKey() {
        // Hardcoded for challenge - prod: env var
        return "SuperSecretKeyForPII2025!!!!1234".getBytes(StandardCharsets.UTF_8); 
    }

    public String encrypt(String ssn) {
        byte[] key = getEncryptionKey();
        // Key was hardcoded for challenge but saw this was typical for production so added validation
        if(key == null || key.length != 32) {
            throw new IllegalArgumentException("Encryption key must be 32 bytes");
        }

        try {
            // Generate random IV for CBC mode
            SecureRandom random = new SecureRandom();
            byte[] iv = new byte[16];
            random.nextBytes(iv);
            IvParameterSpec ivSpec = new IvParameterSpec(iv);

            // Initialize cipher for encryption
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(key, "AES"), ivSpec);
            
            // Encrypt the SSN
            byte[] encrypted = cipher.doFinal(ssn.getBytes(StandardCharsets.UTF_8));
            
            // Combine IV + encrypted data (prepend IV)
            byte[] encryptedWithIv = new byte[iv.length + encrypted.length];
            System.arraycopy(iv, 0, encryptedWithIv, 0, iv.length);
            System.arraycopy(encrypted, 0, encryptedWithIv, iv.length, encrypted.length);
            
            // Encode to Base64 and return
            return Base64.getEncoder().encodeToString(encryptedWithIv);
        } catch (Exception e) {
            throw new RuntimeException("Encryption failed", e);
        }
    }

    public String decrypt(String encryptedSsn) {
        byte[] key = getEncryptionKey();
        if(key == null || key.length != 32) {
            throw new IllegalArgumentException("Encryption key must be 32 bytes");  
        }

        try {
            // Decode from Base64
            byte[] encryptedWithIv = Base64.getDecoder().decode(encryptedSsn);

            // Extract IV from encrypted data (first 16 bytes)
            byte[] iv = new byte[16];
            System.arraycopy(encryptedWithIv, 0, iv, 0, iv.length);

            // Extract encrypted data (remaining bytes)
            byte[] encrypted = new byte[encryptedWithIv.length - iv.length];
            System.arraycopy(encryptedWithIv, iv.length, encrypted, 0, encrypted.length);

            // Initialize cipher for decryption
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(key, "AES"), new IvParameterSpec(iv));

            // Decrypt the data
            byte[] decrypted = cipher.doFinal(encrypted);

            // Return the decrypted string
            return new String(decrypted, StandardCharsets.UTF_8);
            
        } catch (Exception e) {
            throw new RuntimeException("Decryption failed", e);
        }
    }
}

