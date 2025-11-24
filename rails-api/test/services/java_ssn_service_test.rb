require 'test_helper'

class JavaSsnServiceTest < ActiveSupport::TestCase
  # This test doesn't need database fixtures or transactions
  self.use_transactional_tests = false
  # Override fixtures to not load any
  def self.fixtures(*args); end
  
  def setup
    @valid_ssn = "123-45-6789"
    @encrypted_ssn = "encrypted_ssn_string"
  end

  test "should validate SSN successfully" do
    mock_response = stub
    mock_response.stubs(:[]).with('valid').returns(true)
    mock_response.stubs(:[]).with('errorMessage').returns(nil)
    HTTParty.stubs(:post).returns(mock_response)

    result = JavaSsnService.validate_ssn(@valid_ssn)

    assert_equal true, result[:valid]
    assert_nil result[:error_message]
  end

  test "should return validation error when SSN is invalid" do
    mock_response = stub
    mock_response.stubs(:[]).with('valid').returns(false)
    mock_response.stubs(:[]).with('errorMessage').returns('Invalid SSN format')
    HTTParty.stubs(:post).returns(mock_response)

    result = JavaSsnService.validate_ssn("000-00-0000")

    assert_equal false, result[:valid]
    assert_equal 'Invalid SSN format', result[:error_message]
  end

  test "should raise error when validation request fails" do
    HTTParty.stubs(:post).raises(StandardError.new("Connection refused"))

    assert_raises(RuntimeError) do
      JavaSsnService.validate_ssn(@valid_ssn)
    end
  end

  test "should encrypt SSN successfully" do
    mock_response = stub
    mock_response.stubs(:body).returns(@encrypted_ssn)
    HTTParty.stubs(:post).returns(mock_response)

    result = JavaSsnService.encrypt_ssn(@valid_ssn)

    assert_equal @encrypted_ssn, result
  end

  test "should raise error when encryption request fails" do
    HTTParty.stubs(:post).raises(StandardError.new("Connection refused"))

    assert_raises(RuntimeError) do
      JavaSsnService.encrypt_ssn(@valid_ssn)
    end
  end

  test "should decrypt SSN successfully" do
    mock_response = stub
    mock_response.stubs(:body).returns(@valid_ssn)
    HTTParty.stubs(:post).returns(mock_response)

    result = JavaSsnService.decrypt_ssn(@encrypted_ssn)

    assert_equal @valid_ssn, result
  end

  test "should raise error when decryption request fails" do
    HTTParty.stubs(:post).raises(StandardError.new("Connection refused"))

    assert_raises(RuntimeError) do
      JavaSsnService.decrypt_ssn(@encrypted_ssn)
    end
  end
end
