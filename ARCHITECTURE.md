# System Architecture

## Overview

The Secure PII Management System is a full-stack application consisting of three separate services that work together to securely collect, validate, encrypt, store, and display Personal Identifiable Information (PII).

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    React Frontend                           │
│                  (Port 5173 - Vite)                         │
│                                                             │
│  ┌──────────────┐              ┌──────────────┐             │
│  │ PersonForm   │              │ PeopleList   │             │
│  │ Component    │              │ Component    │             │
│  └──────┬───────┘              └──────┬───────┘             │
│         │                             │                     │
│         └──────────────┬──────────────┘                     │
│                        │                                    │
│                        ▼                                    │
│              ┌─────────────────┐                            │
│              │  peopleApi.js   │                            │
│              │  (API Service)  │                            │
│              └─────────────────┘                            │
└────────────────────────┼────────────────────────────────────┘
                         │ HTTP/REST
                         │ (CORS enabled)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Rails API Service                              │
│              (Port 3000)                                    │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Api::PeopleController                               │   │
│  │  - POST /api/people (create)                         │   │
│  │  - GET  /api/people (index)                          │   │
│  └──────────────────────────────────────────────────────┘   │
│         │                              │                    │
│         │                              │                    │
│         ▼                              ▼                    │
│  ┌──────────────┐              ┌──────────────┐             │
│  │ Person Model │              │ Address Model│             │
│  └──────┬───────┘              └──────┬───────┘             │
│         │                             │                     │
│         └──────────────┬──────────────┘                     │
│                        │                                    │
│                        ▼                                    │
│              ┌─────────────────┐                            │
│              │  PostgreSQL DB  │                            │
│              │  (encrypted_ssn)│                            │
│              └─────────────────┘                            │
│                        │                                    │
│                        │                                    │
│         ┌──────────────┴──────────────┐                     │
│         │                             │                     │
│         ▼                             ▼                     │
│  ┌────────────────┐            ┌──────────────┐             │
│  │ JavaSsnService │            │  Validation  │             │
│  │ (HTTParty)     │            │  & Encryption│             │
│  └────────────────┘            └──────────────┘             │
└────────────────────────┼────────────────────────────────────┘
                         │ HTTP/REST
                         │ (localhost:8081)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Java Microservice                              │
│              (Port 8081 - Spring Boot)                      │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  SsnController                                       │   │
│  │  - POST /api/ssn/validate                            │   │
│  │  - POST /api/ssn/encrypt                             │   │
│  │  - POST /api/ssn/decrypt                             │   │
│  └──────────────────────────────────────────────────────┘   │
│         │                              │                    │
│         ▼                              ▼                    │
│  ┌──────────────┐              ┌──────────────┐             │
│  │ SSN          │              │ SSN          │             │
│  │ Validation   │              │ Encryption   │             │
│  │ Service      │              │ Service      │             │
│  └──────────────┘              └──────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

## Service Communication

### Frontend → Rails API

**Protocol**: HTTP/REST  
**Port**: 3000  
**Endpoints**: 
- `GET /api/people` - Fetch all people records
- `POST /api/people` - Create new person record

**Data Flow**: React form submits PII data as JSON → Rails validates → Returns success or validation errors

**Tech Specs**:
- Data Format: JSON (request/response)
- CORS: Enabled for `http://localhost:5173`
- Headers: `Content-Type: application/json`

### Rails API → Java Service

**Protocol**: HTTP/REST  
**Port**: 8081  
**Client**: HTTParty gem  
**Endpoints**:
- `POST /api/ssn/validate` - Validate SSN per SSA standards (returns JSON: `{valid: boolean, errorMessage: string}`)
- `POST /api/ssn/encrypt` - Encrypt SSN using AES-256 (returns plain text encrypted string)
- `POST /api/ssn/decrypt` - Decrypt encrypted SSN (returns plain text SSN)

**Data Flow**: Rails sends SSN as plain text → Java validates/encrypts/decrypts → Returns result or raises error

**Tech Specs**:
- Request Body: Plain text (SSN or encrypted SSN)
- Response: JSON for validation, plain text for encrypt/decrypt
- Headers: `Content-Type: text/plain`
- Error Handling: Raises `RuntimeError` on connection failures

### Rails API → PostgreSQL

**ORM**: ActiveRecord  
**Connection**: Connection pooling configured (10 connections small-medium project)

**Data Flow**: Rails creates Person record → Creates Address record in same database transaction → Both commit together or both roll back (prevents orphaned records)

**Tech Specs**:
- Transactions: Person + Address created together (all-or-nothing: if either fails, both are rolled back)
- Relationships: `Person` has_one `Address` (dependent: :destroy)

## Security Implementation

- **In Transit**: HTTP used for local development (HTTPS/TLS would be configured for production)
- **At Rest**: AES-256-CBC encryption with random IV - Java service encrypts SSN before storing in PostgreSQL as Base64-encoded string
- **Display**: SSN obfuscated server-side - only last 4 digits shown as `***-**-1234` (full SSN never sent to frontend)
- **Additional**: 
  - Input validation: HTML5 (client-side), Rails models (server-side), SSN validation per SSA standards (Java service)
  - Error handling: No sensitive data in error messages
  - CORS: Configured to allow requests from `http://localhost:5173` (production: restricted to production domain)

## Database Schema

### People Table
- `id` (bigint, primary key, auto-increment)
- `first_name` (string, max 50, required)
- `middle_name` (string, max 50, required)
- `middle_name_override` (boolean, default: false, required)
- `last_name` (string, max 50, required)
- `encrypted_ssn` (text, required)
- `created_at` (datetime, required)
- `updated_at` (datetime, required)

### Addresses Table
- `id` (bigint, primary key, auto-increment)
- `person_id` (bigint, foreign key to people.id, required)
- `street_address_1` (string, required)
- `street_address_2` (string, optional)
- `city` (string, required)
- `state_abbreviation` (string, required)
- `zip_code` (string, required)
- `created_at` (datetime, required)
- `updated_at` (datetime, required)

## Design Decisions and Rationale

### Architectural Decisions

#### AES-256-CBC with IV
- **Decision**: Use CBC mode with random IV instead of ECB
- **Rationale**: CBC with IV ensures same SSN encrypts to different values each time (ECB mode is insecure - same plaintext = same ciphertext)

#### Transaction for Person + Address Creation
- **Decision**: Wrap Person and Address creation in database transaction
- **Rationale**: Forward-thinking approach - ensures data integrity, prevents orphaned records, enables future support for multiple addresses per person

### Technology Choices

#### HTTParty for Java Service Communication
- **Decision**: Use HTTParty gem for HTTP requests
- **Rationale**: Chose over Faraday (more features but more complex) and Net::HTTP (built-in but verbose) for simplicity and Rails-friendly syntax

#### React Router for Navigation
- **Decision**: Use React Router for client-side routing
- **Rationale**: Industry standard for React, enables single-page application behavior with smooth navigation between form and list pages

#### Tailwind CSS for Styling
- **Decision**: Use Tailwind CSS for styling
- **Rationale**: Utility-first framework for quick development and responsive design
