class Yummy < ApplicationRecord
  belongs_to :user
  belongs_to :recipe, counter_cache: true
  # counter_cache: true :yummyが作成されたり削除したりする度に、yummies_countカラムを自動的に更新し、カウントする
end
