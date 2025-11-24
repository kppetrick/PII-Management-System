require 'test_helper'

class Api::PeopleControllerTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = true
  
  def setup
    Person.destroy_all
    Address.destroy_all
        JavaSsnService.stubs(:validate_ssn).returns({ valid: true })
        JavaSsnService.stubs(:encrypt_ssn).returns("encrypted_ssn_string")
        JavaSsnService.stubs(:decrypt_ssn).returns("123-45-6789")
      end

    def create_person_with_address(overrides = {})
      person = Person.create!(
        first_name: overrides[:first_name] || "John",
        middle_name: overrides[:middle_name] || "Michael",
        last_name: overrides[:last_name] || "Doe",
        encrypted_ssn: overrides[:encrypted_ssn] || "encrypted_ssn_1"
      )
      Address.create!(
        person: person,
        street_address_1: overrides[:street_address_1] || "123 Main St",
        street_address_2: overrides[:street_address_2],
        city: overrides[:city] || "Overland Park",
        state_abbreviation: overrides[:state_abbreviation] || "KS",
        zip_code: overrides[:zip_code] || "66213"
      )
      person
    end

    def create_person_without_address(overrides = {})
      Person.create!(
        first_name: overrides[:first_name] || "John",
        middle_name: overrides[:middle_name] || "Michael",
        last_name: overrides[:last_name] || "Doe",
        encrypted_ssn: overrides[:encrypted_ssn] || "encrypted_ssn_1"
      )
    end

    def person_params(overrides = {})
      {
        first_name: overrides[:first_name] || "John",
        middle_name: overrides[:middle_name] || "Doe",
        last_name: overrides[:last_name] || "Smith",
        ssn: overrides[:ssn] || "123-45-6789",
        street_address_1: overrides[:street_address_1] || "123 Main St",
        street_address_2: overrides[:street_address_2],
        city: overrides[:city] || "Overland Park",
        state_abbreviation: overrides[:state_abbreviation] || "KS",
        zip_code: overrides[:zip_code] || "66213"
      }.merge(overrides)
    end

    def record_counts
      { person: Person.count, address: Address.count }
    end

    def assert_no_records_created(initial_counts)
      assert_equal initial_counts[:person], Person.count
      assert_equal initial_counts[:address], Address.count
    end

    def assert_records_created(initial_counts, person_delta: 1, address_delta: 1)
      assert_equal initial_counts[:person] + person_delta, Person.count
      assert_equal initial_counts[:address] + address_delta, Address.count
    end

    def get_people_json
      get api_people_path, as: :json
      assert_response :ok
      JSON.parse(response.body)
    end

  test "should create person with valid data" do
    initial_counts = record_counts
    post api_people_path, params: { person: person_params(street_address_2: "Apt 4B") }, as: :json
    assert_response :created

    json_response = JSON.parse(response.body)
    assert json_response["id"].present?
    assert_equal "Person created successfully", json_response["message"]
    assert_records_created(initial_counts)
    
    person = Person.find(json_response["id"])
    assert_equal "John", person.first_name
    assert_equal "Doe", person.middle_name
    assert_equal "Smith", person.last_name
    assert_not_equal "123-45-6789", person.encrypted_ssn
    assert_equal "encrypted_ssn_string", person.encrypted_ssn
    assert_equal false, person.middle_name_override
    
    assert person.address.present?
    address = person.address
    assert_equal "123 Main St", address.street_address_1
    assert_equal "Apt 4B", address.street_address_2
    assert_equal "Overland Park", address.city
    assert_equal "KS", address.state_abbreviation
    assert_equal "66213", address.zip_code
  end

  test "should reject invalid SSN" do
    JavaSsnService.stubs(:validate_ssn).returns({ valid: false, error_message: "SSN is a known invalid test number" })
    initial_counts = record_counts
    post api_people_path, params: { person: person_params(ssn: "000-45-6789") }, as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal "SSN is a known invalid test number", json_response["error"]
    assert_no_records_created(initial_counts)
  end

  test "should reject missing required name fields" do
    initial_counts = record_counts
    post api_people_path, params: { person: person_params(first_name: "") }, as: :json
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["error"].present?
    assert_no_records_created(initial_counts)
  end

  test "should reject missing required address fields" do
    initial_counts = record_counts
    post api_people_path, params: { person: person_params(city: "") }, as: :json
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response["error"].present?
    assert_no_records_created(initial_counts)
  end

  test "should handle Java service connection error" do
    JavaSsnService.stubs(:validate_ssn).raises(RuntimeError.new("Service error"))
    initial_counts = record_counts
    post api_people_path, params: { person: person_params }, as: :json
    assert_response :internal_server_error

    json_response = JSON.parse(response.body)
    assert json_response["error"].present?
    assert_no_records_created(initial_counts)
  end

  test "should handle middle_name_override correctly" do
    post api_people_path, params: { person: person_params(middle_name: "", middle_name_override: true) }, as: :json  
    assert_response :created

    json_response = JSON.parse(response.body)
    person = Person.find(json_response["id"])
    assert_equal "", person.middle_name
    assert_equal true, person.middle_name_override
  end

  test "should return empty array when no people exist" do
    json_response = get_people_json
    assert_equal [], json_response
  end

  test "should return all people with obfuscated SSN" do
    create_person_with_address
    create_person_with_address(first_name: "Jane", middle_name: "Marie", encrypted_ssn: "encrypted_ssn_2", street_address_1: "456 Main St")

    json_response = get_people_json
    assert_equal 2, json_response.length
    json_response.each do |person|
      assert_equal "***-**-6789", person["ssn"]
    end
  end

  test "should handle decryption error gracefully" do
    create_person_with_address

    JavaSsnService.stubs(:decrypt_ssn).raises(RuntimeError.new("Decryption error"))
    json_response = get_people_json
    assert_equal 1, json_response.length
    assert_equal "***-**-****", json_response[0]["ssn"]
  end

  test "should return person without address as nil in index" do
    create_person_without_address
    create_person_with_address(first_name: "Jane")

    json_response = get_people_json
    assert_equal 2, json_response.length
    
    person_without_address = json_response.find { |p| p["address"].nil? }
    person_with_address = json_response.find { |p| p["address"].present? }
    
    assert_not_nil person_without_address
    assert_nil person_without_address["address"]
    assert_not_nil person_with_address
    assert_not_nil person_with_address["address"]
  end

  test "should handle encryption error during create" do
    JavaSsnService.stubs(:encrypt_ssn).raises(RuntimeError.new("Encryption error"))
    initial_counts = record_counts
    post api_people_path, params: { person: person_params }, as: :json
    assert_response :internal_server_error

    json_response = JSON.parse(response.body)
    assert json_response["error"].present?
    assert_no_records_created(initial_counts)
  end
end