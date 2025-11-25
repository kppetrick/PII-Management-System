# Secure PII Management System

## Prerequisites

- **Java**: 17
- **Maven**: (for building Java service)
- **Ruby**: 3.4.7
- **Rails**: 8.1.1
- **Node.js**: (for React frontend)
- **npm**: (comes with Node.js)
- **PostgreSQL**: (for database)

## Setup Instructions

### Java Service
```bash
cd java-service
mvn clean install
```

### Rails API
```bash
cd rails-api
bundle install
rails db:create
rails db:migrate
```

### React Frontend
```bash
cd react-frontend
npm install
```

## Running the Application

Start services in separate terminals:

```bash
# Terminal 1: Java Service (Port 8081)
cd java-service && mvn spring-boot:run

# Terminal 2: Rails API (Port 3000)
cd rails-api && rails server

# Terminal 3: React Frontend (Port 5173)
cd react-frontend && npm run dev
```

Access at `http://localhost:5173`

## Running Tests

```bash
# Java Service
cd java-service && mvn test

# Rails API
cd rails-api && rails test

# React Frontend
cd react-frontend && npm test
```

## Time Spent Summary

**Technical Requirements**: ~10 hours
- Java service: Quick implementation due to prior experience
- Rails API: Time spent learning Rails conventions and patterns (similar to Java but with its own style)
- Database: Minimal time - Rails migration framework generated SQL from migration files
- React frontend: Some research and AI assistance for new concepts and sticking points

**Functional Requirements**: ~4 hours
- PII data collection form, SSN validation, security implementation, display page

**Testing Requirements**: ~4-5 hours
- Writing tests: 2-3 hours
- Debugging test issues: ~2 hours (database connection pool issues, mocking setup, etc.)

**Documentation**: ~2-3 hours
- README.md and ARCHITECTURE.md

**Total**: ~20-22 hours

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
- **Jest setup and troubleshooting**: Used AI to set up Jest and React Testing Library, including installing dependencies, configuring `package.json` and `.babelrc`, and troubleshooting issues like `import.meta.env` and missing Babel presets. AI also helped debug the need for `jest.mock()` to be called before imports.
**Documentation:**
- **Architecture diagram**: AI generated the architecture diagram in `ARCHITECTURE.md` based on my description of the services (React Frontend, Rails API, Java Microservice) and how they communicate and flow together.


## Implementation Notes

- **Code comments in encryption service**: Added step-by-step comments in the encryption/decryption methods because encryption was new to me. I wanted to understand what each step did for future reference and to ensure I could explain the process clearly.
- **HTTP client choice**: Used AI to compare HTTP client options (httparty, faraday, net/http) for calling the Java service. Chose httparty for simplicity and ease of use.

## Assumptions

- **Area number validation**: The requirement states "Area number may allow 900-999". I interpret this as allowing 900-999 in addition to standard ranges, rather than restricting to only 900-999. Only 000 and 666 are rejected.
- **Encryption key management**: Used a hardcoded 32-byte key for AES-256 encryption in the Java service for simplicity during the challenge. In production, keys should be stored in environment variables or a secure key management service.
- **Address field requirements**: The challenge states "Current Address (required)" but doesn't specify which individual address fields are required. I assumed all address fields are required except `street_address_2` (which is commonly optional for apartment numbers, suite numbers, etc.). Therefore, `street_address_1`, `city`, `state_abbreviation`, and `zip_code` are required fields, while `street_address_2` is optional.

## Bonus Points (Optional Features)

I researched each bonus point to see what made the most sense for my time and what tools/libraries were available. I asked AI for time estimates to accomplish each and focused on core requirements first. Here's my approach for each:

### Docker Compose
Researched Docker Compose - would allow reviewers to run `docker-compose up` for automatic setup. Happy to implement after the holiday break if desired.

### Input Sanitization and XSS Prevention
Rails auto-escaping and React controlled components provide basic XSS protection. Would add explicit sanitization using the `Loofah` gem for defense in depth in production.

### Rate Limiting
Implemented using `rack-attack` gem. Rate limits: POST requests (creating PII) - 10/minute, GET requests (reading PII) - 60/minute, all API requests - 100/minute per IP.

### Audit Logging for PII Access
Would add logging infrastructure (database tables, middleware, model callbacks) to track all PII access attempts and encryption/decryption operations. Could use gems like `audited` or `paper_trail` for automatic audit trails.

### Additional Validation
Would add:
- **ZIP code validation**: `validates_zipcode` gem for 5-digit or ZIP+4 format
- **State abbreviation validation**: `us_states` gem with dropdown component
