# Secure PII Management System

## Setup Instructions
_(To be documented)_

## Running the Application
_(To be documented)_

## AI Usage

I used AI (Cursor's AI assistant) as a coding tool and assistant throughout this project. Here's how:

**Java Service:**
- **Encryption learning**: Used AI to learn about ECB vs CBC encryption modes. AI explained that CBC + IV is more secure and doesn't encrypt the same SSN to the same value each time (more realistic for production). Based on this, I chose CBC mode with IV.
- **Test skeletons**: AI created test skeletons based on the code I wrote. I then wrote all the actual test implementations myself.
- **Controller testing**: Had never written controller tests before. AI provided assistance with the first controller test, then I mimicked the pattern for the remaining controller tests.

**Rails API:**
- **Mocking library selection**: Asked AI what's most commonly used for mocking in Rails controller tests. AI explained that Mocha is widely used and standard practice, while built-in minitest/mock is also acceptable. Chose Mocha for cleaner syntax and because it's a common tool in Rails projects.
- **Java SSN service test help**: Used AI to help with testing the JavaSsnService in Rails, including proper mocking techniques with Mocha and handling HTTParty stubs to avoid test hangs.
- **Database connection debugging**: Used AI extensively to debug database connection pool exhaustion issues that prevented Rails tests from running. AI helped identify problems with parallel test execution, connection pool sizing, and multiple database instances being open simultaneously. This included troubleshooting `ActiveRecord::ConnectionTimeoutError`, fixing database.yml configuration conflicts, and implementing proper connection cleanup in test_helper.rb.

**React Frontend:**
- **CORS troubleshooting**: Used AI to debug CORS errors when connecting React frontend to Rails API. AI identified the need to uncomment and configure rack-cors in Rails, and helped troubleshoot connection issues.
- **Tailwind CSS styling**: AI provided guidance on responsive styling with Tailwind CSS, including mobile-first design patterns, grid layouts, and component styling for both form and list components.


## Implementation Notes

- **Code comments in encryption service**: Added step-by-step comments in the encryption/decryption methods because encryption was new to me. I wanted to understand what each step did for future reference and to ensure I could explain the process clearly.

- **HTTP client choice**: Used AI to compare HTTP client options (httparty, faraday, net/http) for calling the Java service. Chose httparty for simplicity and ease of use.

## Assumptions

- **Area number validation**: The requirement states "Area number may allow 900-999". I interpret this as allowing 900-999 in addition to standard ranges, rather than restricting to only 900-999. Only 000 and 666 are rejected.

- **Encryption key management**: Used a hardcoded 32-byte key for AES-256 encryption in the Java service for simplicity during the challenge. In production, keys should be stored in environment variables or a secure key management service.

- **Address field requirements**: The challenge states "Current Address (required)" but doesn't specify which individual address fields are required. I assumed all address fields are required except `street_address_2` (which is commonly optional for apartment numbers, suite numbers, etc.). Therefore, `street_address_1`, `city`, `state_abbreviation`, and `zip_code` are required fields, while `street_address_2` is optional.