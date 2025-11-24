class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :person, null: false, foreign_key: true
      t.string :street_address_1, null: false
      t.string :street_address_2
      t.string :city, null: false
      t.string :state_abbreviation, null: false
      t.string :zip_code, null: false

      t.timestamps
    end
  end
end
