class AddUserToForms < ActiveRecord::Migration
  def change
    add_reference :forms, :user, index: true
    add_foreign_key :forms, :users
  end
end
