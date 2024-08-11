class RecipeImageUploader < CarrierWave::Uploader::Base
  # 画像処理ライブラリの指定: RMagickかMiniMagickを指定する
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # このアップローダーで使用するストレージの指定
  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # アップロードされたファイルの保存先の指定
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    # アップロードした画像ファイルは、public/uploads/モデル名/画像のカラム名/id」配下に保存される
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  # ファイルがアップロードされていない場合のデフォルト画像を指定する
  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'recipe_no_image.png'
  end
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # アップロード時に画像のサイズ変更などを行える
  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # オリジナル画像とは別に、サムネイルなどの異なるサイズの画像を作成
  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # 許可する拡張子の設定
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # ファイル名の変更
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
