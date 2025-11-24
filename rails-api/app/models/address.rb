class Address < ApplicationRecord
  belongs_to :person

  validates :street_address_1, presence: true, length: { maximum: 255 }
  validates :street_address_2, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 50 }
  validates :state_abbreviation, presence: true, length: { is: 2 }
  validates :zip_code, presence: true, length: { minimum: 5, maximum: 10 }
end
