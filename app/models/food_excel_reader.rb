# Excelファイルを読み込むためのクラス
require 'roo'

class FoodExcelReader
  def self.read
    ExcelReader.read_excel('food_excel.xlsx')
    #　concerns/excel_reader.rbのread_excelメソッドを呼び出す
  end
end
