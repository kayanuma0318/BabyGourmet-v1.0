class Food < ApplicationRecord
  has_many :food_nutrients
  has_many :nutrients, through: :food_nutrients

  def self.import_from_excel(file_path)
    xlsx = Roo::Excelx.new(file_path)
    # Excelファイルを開ける

    sheet = xlsx.sheet(0)
    # Excelの最初のシートを使用する

    header =  sheet.row(1)
    # 1行目をヘッダーとして取得

    (2..sheet.last_row).each do |row|
      # 2行目から最後まで1行ずつ処理していく
      food_data = {
        name: sheet.cell(row, 'A').to_s,
        # Aの列を、文字列のnameに設定
        category: sheet.cell(row, 'B').to_s,
        # Bの列をcategoryに設定
        unit: sheet.cell(row, 'C').to_s,
        # Cの列をunitに設定
      }
      Food.find_or_create_by!(food_data)
      # 同じ名前の食品が一致するレコードが存在すれば取得、なければ新規作成
      # find_or_create_by! = !をつけると失敗時に例外が発生する
    end
  end
end
