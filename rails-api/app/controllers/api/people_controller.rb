class Api::PeopleController < ApplicationController
  def create
    ssn = person_params[:ssn]
    validation_results = JavaSsnService.validate_ssn(ssn)
    unless validation_results[:valid]
      render json: { error: validation_results[:error_message] }, status: :unprocessable_entity
      return
    end

    encrypted_ssn = JavaSsnService.encrypt_ssn(ssn)
    person = nil
    ActiveRecord::Base.transaction do
      person = Person.create!(
        first_name: person_params[:first_name],
        middle_name: person_params[:middle_name],
        middle_name_override: person_params[:middle_name_override] || false,
        last_name: person_params[:last_name],
        encrypted_ssn: encrypted_ssn
      )
      Address.create!(
        person: person,
        street_address_1: person_params[:street_address_1],
        street_address_2: person_params[:street_address_2],
        city: person_params[:city],
        state_abbreviation: person_params[:state_abbreviation],
        zip_code: person_params[:zip_code]
      )
    end
    render json: { id: person.id, message: "Person created successfully" }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue RuntimeError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def index
    people = Person.includes(:address).all
    render json: people.map { |person|
{
    id: person.id,
    first_name: person.first_name,
    middle_name: person.middle_name,
    last_name: person.last_name,
    ssn: obfuscate_ssn(person.encrypted_ssn),
    address: person.address ? {
      street_address_1: person.address.street_address_1,
      street_address_2: person.address.street_address_2,
      city: person.address.city,
      state_abbreviation: person.address.state_abbreviation,
      zip_code: person.address.zip_code
    } : nil
}}
  end

  private
  def person_params
    params.require(:person).permit(
      :first_name,
      :middle_name,
      :middle_name_override,
      :last_name,
      :ssn,
      :street_address_1,
      :street_address_2,
      :city,
      :state_abbreviation,
      :zip_code
    )
  end

  def obfuscate_ssn(encrypted_ssn)
    decrypted_ssn = JavaSsnService.decrypt_ssn(encrypted_ssn)
    last_four = decrypted_ssn[-4..-1]
    "***-**-#{last_four}"
  rescue RuntimeError
    "***-**-****"
  end
end