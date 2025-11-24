require "test_helper"

class AddressTest < ActiveSupport::TestCase
  # Street Address 1 Tests
  test "should require street_address_1" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "",  
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert_not address.valid?
    assert_includes address.errors[:street_address_1], "can't be blank"
  end

  test "should limit street_address_1 to 255 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "A" * 256,  
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert_not address.valid?
    assert_includes address.errors[:street_address_1], "is too long (maximum is 255 characters)"
  end

  test "should accept street_address_1 with exactly 255 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "A" * 255,
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  # Street Address 2 Tests (Optional)
  test "should allow blank street_address_2" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      street_address_2: "",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  test "should limit street_address_2 to 255 characters when present" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      street_address_2: "A" * 256,
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert_not address.valid?
    assert_includes address.errors[:street_address_2], "is too long (maximum is 255 characters)"
  end

  test "should accept street_address_2 with exactly 255 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      street_address_2: "A" * 255,
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  # City Tests
  test "should require city" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert_not address.valid?
    assert_includes address.errors[:city], "can't be blank"
  end

  test "should limit city to 50 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "A" * 51,
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert_not address.valid?
    assert_includes address.errors[:city], "is too long (maximum is 50 characters)"
  end

  test "should accept city with exactly 50 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "A" * 50,  
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  # State Abbreviation Tests
  test "should require state_abbreviation" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "",
      zip_code: "66213"
    )
    assert_not address.valid?
    assert_includes address.errors[:state_abbreviation], "can't be blank"
  end

  test "should require state_abbreviation to be exactly 2 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    
    address1 = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "K",
      zip_code: "66213"
    )
    assert_not address1.valid?
    assert_includes address1.errors[:state_abbreviation], "is the wrong length (should be 2 characters)"
    
    address2 = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KSS",
      zip_code: "66213"
    )
    assert_not address2.valid?
    assert_includes address2.errors[:state_abbreviation], "is the wrong length (should be 2 characters)"
  end

  test "should accept state_abbreviation with exactly 2 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  # ZIP Code Tests
  test "should require zip_code" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: ""
    )
    assert_not address.valid?
    assert_includes address.errors[:zip_code], "can't be blank"
  end

  test "should require zip_code to be at least 5 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "1234"
    )
    assert_not address.valid?
    assert_includes address.errors[:zip_code], "is too short (minimum is 5 characters)"
  end

  test "should limit zip_code to 10 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "12345678901"
    )
    assert_not address.valid?
    assert_includes address.errors[:zip_code], "is too long (maximum is 10 characters)"
  end

  test "should accept zip_code with 5 characters" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  test "should accept zip_code with 10 characters (ZIP+4 format)" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213-1234"
    )
    assert address.valid?
  end

  # Valid Address Tests
  test "should be valid with all required fields" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  test "should be valid with all fields including optional street_address_2" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.new(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      street_address_2: "Suite 200",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert address.valid?
  end

  # Association Tests
  test "should belong to person" do
    person = Person.create!(
      first_name: "John",
      middle_name: "Middle",
      last_name: "Doe",
      encrypted_ssn: "encrypted123"
    )
    address = Address.create!(
      person: person,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert_equal person, address.person
  end

  test "should require person (belongs_to validation)" do
    address = Address.new(
      person: nil,
      street_address_1: "12345 Metcalf Ave",
      city: "Overland Park",
      state_abbreviation: "KS",
      zip_code: "66213"
    )
    assert_not address.valid?
    assert_includes address.errors[:person], "must exist"
  end
end
