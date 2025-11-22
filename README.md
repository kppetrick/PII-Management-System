# Secure PII Management System

## Setup Instructions
_(To be documented)_

## Running the Application
_(To be documented)_

## Assumptions

- **Area number validation**: The requirement states "Area number may allow 900-999". I interpret this as allowing 900-999 in addition to standard ranges, rather than restricting to only 900-999. Only 000 and 666 are rejected.

- **Encryption key management**: Used a hardcoded 32-byte key for AES-256 encryption in the Java service for simplicity during the challenge. In production, keys should be stored in environment variables or a secure key management service.