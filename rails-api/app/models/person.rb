class Person < ApplicationRecord
    has_one :address, dependent: :destroy

    validates :first_name, presence: true, length: { maximum: 50 }
    validates :middle_name, presence: true, length: { maximum: 50 }, unless: :middle_name_override?
    validates :last_name, presence: true, length: { maximum: 50 }
    validates :encrypted_ssn, presence: true
end
