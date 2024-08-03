require 'roo'

class NutrientExcelReader
  def self.read
    ExcelReader.read_excel('nutrient_excel.xlsx')
    #　concerns/excel_reader.rbのread_excelメソッドを呼び出す
  end
end