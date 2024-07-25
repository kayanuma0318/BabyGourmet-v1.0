class Nutrient < ApplicationRecord
  has_many :food_nutrients
  has_many :foods, through: :food_nutrients

  def self.import_from_excel(file_path)
    xlsx = Roo::Excelx.new(file_path)
    # Excelファイルを開ける
    sheet = xlsx.sheet(0)
    # Excelの最初のシートを使用する
    header =  sheet.row(1)
    # 1行目をヘッダーとして取得

    (2..sheet.last_row).each do |row|
      # 2行目から最後まで1行ずつ処理していく
      nutrients_data= {
        energy: convert_to_zero(sheet.cell(row, 'A').to_f),
        protein: convert_to_zero(sheet.cell(row, 'B').to_f),
        dietary_fiber: convert_to_zero(sheet.cell(row, 'C').to_f),
        calcium: convert_to_zero(sheet.cell(row, 'D').to_f),
        magnesium: convert_to_zero(sheet.cell(row, 'E').to_f),
        phosphorus: convert_to_zero(sheet.cell(row, 'F').to_f),
        iron: convert_to_zero(sheet.cell(row, 'G').to_f),
        zinc: convert_to_zero(sheet.cell(row, 'H').to_f),
        iodine: convert_to_zero(sheet.cell(row, 'I').to_f),
        vitamin_d: convert_to_zero(sheet.cell(row, 'J').to_f),
        vitamin_b6: convert_to_zero(sheet.cell(row, 'K').to_f),
        vitamin_b12: convert_to_zero(sheet.cell(row, 'L').to_f),
        folate: convert_to_zero(sheet.cell(row, 'M').to_f),
        vitamin_c: convert_to_zero(sheet.cell(row, 'N').to_f),
        salt_equivalent: convert_to_zero(sheet.cell(row, 'O').to_f),
      }

      Nutrient.find_or_create_by!(nutrients_data)
      # 同じ名前の栄養素が一致するレコードが存在すれば取得、なければ新規作成
    end
  end

  def self.convert_to_zero(value)
    # 引数の値がnilか空文字列の場合、0.0を返す
    if value.nil? || value.to_s.strip.empty?
      0.0
    else
      value
    end
  end
end
