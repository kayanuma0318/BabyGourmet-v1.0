# Excelファイルを読み込むためのモジュール
module ExcelReader
  def self.read_excel
    file_path = Rails.root.join(file_name).to_s
    # Rails.root :一番上の階層からfood_excel.xlsxを探す
    # join :ファイル名を結合
    # to_s :path名を文字列に変換
    # file_name :引数として受け取るファイル名を動的に変更
    puts "File exists: #{File.exist?(file_path)}"
    # {File.exist?(file_path)} :ファイルが(file_path)に存在するかどうかを確認
    if File.exist?(file_path)
      # ファイルが存在する場合
      xlsx = Roo::Excelx.new(file_path)
      # ファイルを開き、xlsxに代入
      puts xlsx.info
      # xlsxの情報を表示
    else
      puts "File not found at #{file_path}"
    end
  end
end