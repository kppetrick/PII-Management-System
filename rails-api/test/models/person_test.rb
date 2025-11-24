require "test_helper"

class PersonTest < ActiveSupport::TestCase
  # First Name Tests
  test "should require first_name" do
    person = Person.new(
      first_name: "",
      last_name: "Doe",
      middle_name: "Middle",
      encrypted_ssn: "encrypted123"
    )
    assert_not person.valid?
    assert_includes person.errors[:first_name], "can't be blank"
  end

  test "should limit first_name to 50 characters" do
    person = Person.new(
      first_name: "A" * 51,  
      last_name: "Doe",
      middle_name: "Middle",
      encrypted_ssn: "encrypted123"
    )
    assert_not person.valid?
    assert_includes person.errors[:first_name], "is too long (maximum is 50 characters)"
  end

  test "should accept first_name with exactly 50 characters" do
    person = Person.new(
      first_name: "A" * 50,  
      last_name: "Doe",
      middle_name: "Middle",
      encrypted_ssn: "encrypted123"
    )
    assert person.valid?
  end

  # Middle Name Tests
  test "should require middle_name when middle_name_override is false" do
    person = Person.new(
      first_name: "John",
      last_name: "Doe",
      middle_name: "",  
      middle_name_override: false,
      encrypted_ssn: "encrypted123"
    )
    assert_not person.valid?
    assert_includes person.errors[:middle_name], "can't be blank"
  end

  test "should allow blank middle_name when middle_name_override is true" do
    person = Person.new(
      first_name: "John",
      last_name: "Doe",
      middle_name: "",  
      middle_name_override: true,
      encrypted_ssn: "encrypted123"
    )
    assert person.valid?
  end

  test "should limit middle_name to 50 characters" do
    person = Person.new(
      first_name: "John",
      last_name: "Doe",
      middle_name: "A" * 51, 
      encrypted_ssn: "encrypted123"
    )
    assert_not person.valid?
    assert_includes person.errors[:middle_name], "is too long (maximum is 50 characters)"
  end

  test "should accept middle_name with exactly 50 characters" do
    person = Person.new(
      first_name: "John",
      last_name: "Doe",
      middle_name: "A" * 50,  
      encrypted_ssn: "encrypted123"
    )
    assert person.valid?
  end

  # Last Name Tests
  test "should require last_name" do
    person = Person.new(
      first_name: "John",
      last_name: "", 
      middle_name: "Middle",
      encrypted_ssn: "encrypted123"
    )
    assert_not person.valid?
    assert_includes person.errors[:last_name], "can't be blank"
  end

  test "should limit last_name to 50 characters" do
    person = Person.new(
      first_name: "John",
      last_name: "A" * 51,  
      middle_name: "Middle",
      encrypted_ssn: "encrypted123"
    )
    assert_not person.valid?
    assert_includes person.errors[:last_name], "is too long (maximum is 50 characters)"
  end

  test "should accept last_name with exactly 50 characters" do
    person = Person.new(
      first_name: "John",
      last_name: "A" * 50,  
      middle_name: "Middle",
      encrypted_ssn: "encrypted123"
    )
    assert person.valid?
  end

  # Encrypted SSN Tests
  test "should require encrypted_ssn" do
    person = Person.new(
      first_name: "John",
      last_name: "Doe",
      middle_name: "Middle",
      encrypted_ssn: ""  
    )
    assert_not person.valid?
    assert_includes person.errors[:encrypted_ssn], "can't be blank"
  end

  # Valid Person Tests
  test "should be valid with all required fields" do
    person = Person.new(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    assert person.valid?
  end

  test "should be valid with middle_name_override true and blank middle_name" do
    person = Person.new(
      first_name: "John",
      middle_name: "",  
      middle_name_override: true,
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    assert person.valid?
  end

  # Association Tests
  test "should have one address" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.create!(
      person: person,
      street_address_1: "123 Main St",
      city: "Springfield",
      state_abbreviation: "IL",
      zip_code: "62701"
    )
    assert_equal address, person.address
  end

  test "should destroy associated address when person is destroyed" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.create!(
      person: person,
      street_address_1: "123 Main St",
      city: "Springfield",
      state_abbreviation: "IL",
      zip_code: "62701"
    )
    address_id = address.id
    person.destroy
    assert_nil Address.find_by(id: address_id)
  end
end
