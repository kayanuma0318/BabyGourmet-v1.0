class CreateYummies < ActiveRecord::Migration[7.1]
  def change
    create_table :yummies do |t|
      t.references :user, foreign_key: true
      t.references :recipe, foreign_key: true

      t.timestamps
    end
  end
end
