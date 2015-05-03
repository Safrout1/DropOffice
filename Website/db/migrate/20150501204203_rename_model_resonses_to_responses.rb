class RenameModelResonsesToResponses < ActiveRecord::Migration
  def change
    rename_table :resonses, :responses
  end
end
