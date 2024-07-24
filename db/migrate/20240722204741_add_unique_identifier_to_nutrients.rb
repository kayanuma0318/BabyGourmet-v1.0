class AddUniqueIdentifierToNutrients < ActiveRecord::Migration[7.1]
  def change
    add_column :nutrients, :Unique_identifier, :string
  end
end
