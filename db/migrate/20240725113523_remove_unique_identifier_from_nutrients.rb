class RemoveUniqueIdentifierFromNutrients < ActiveRecord::Migration[7.1]
  def change
    remove_column :nutrients, :Unique_identifier, :string
  end
end
