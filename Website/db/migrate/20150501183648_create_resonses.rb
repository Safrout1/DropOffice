class CreateResonses < ActiveRecord::Migration
  def change
    create_table :resonses do |t|
      t.text :questions
      t.text :response
      t.references :form, index: true

      t.timestamps null: false
    end
    add_foreign_key :resonses, :forms
  end
end
