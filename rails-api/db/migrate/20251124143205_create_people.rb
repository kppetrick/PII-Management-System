class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.string :first_name, null: false, limit: 50
      t.string :middle_name, null: false, limit: 50
      t.boolean :middle_name_override, null: false, default: false
      t.string :last_name, null: false, limit: 50
      t.text :encrypted_ssn, null: false

      t.timestamps
    end
  end
end
