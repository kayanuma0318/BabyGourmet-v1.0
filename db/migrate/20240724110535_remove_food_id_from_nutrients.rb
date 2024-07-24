class RemoveFoodIdFromNutrients < ActiveRecord::Migration[7.1]
  def change
    remove_reference :nutrients, :food, foreign_key: true, index: true
  end
end
