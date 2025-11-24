require 'httparty'

class JavaSsnService
  BASE_URL = 'http://localhost:8081'

  def self.validate_ssn(ssn)
    begin
      response = HTTParty.post(
        "#{BASE_URL}/api/ssn/validate",
        body: ssn,
        headers: { 'Content-Type' => 'text/plain' }
      )
      
      {
        valid: response['valid'],
        error_message: response['errorMessage']
      }
    rescue => e
      raise "Unable to validate SSN: #{e.message}"
    end
  end

  def self.encrypt_ssn(ssn)
    begin
      response = HTTParty.post(
        "#{BASE_URL}/api/ssn/encrypt",
        body: ssn,
        headers: { 'Content-Type' => 'text/plain' }
      )
      
      response.body
    rescue => e
      raise "Unable to encrypt SSN: #{e.message}"
    end
  end

  def self.decrypt_ssn(encrypted_ssn)
    begin
      response = HTTParty.post(
        "#{BASE_URL}/api/ssn/decrypt",
        body: encrypted_ssn,
        headers: { 'Content-Type' => 'text/plain' }
      )
      
      response.body
    rescue => e
      raise "Unable to decrypt SSN: #{e.message}"
    end
  end
end
