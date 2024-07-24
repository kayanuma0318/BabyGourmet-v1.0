class CreateNutrients < ActiveRecord::Migration[7.1]
  def change
    create_table :nutrients do |t|
    t.float :energy
    t.float :protein
    t.float :dietary_fiber
    t.float :calcium
    t.float :magnesium
    t.float :phosphorus
    t.float :iron
    t.float :zinc
    t.float :iodine
    t.float :vitamin_d
    t.float :vitamin_b6
    t.float :vitamin_b12
    t.float :folate
    t.float :vitamin_c
    t.float :salt_equivalent

      t.timestamps
    end
  end
end
