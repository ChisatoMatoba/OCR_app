class ImagesController < ApplicationController
  def index
    @images = Image.includes(:book).all
  end

  def new
    @image = Image.new
    @book = Book.find_by(id: params[:book_id])
  end

  def check_existence
    book_id = params[:book_id]
    page_number = params[:page_number]
    book = Book.find_by(id: book_id)
    image_exists = book.images.exists?(page_number: page_number)
    render json: { exists: image_exists }
  end

  def create
    book_id = params[:book_id]
    @book = Book.find_by(id: book_id)

    uploaded_file = params[:image][:file]
    page_number = params[:image][:page_number]

    ActiveRecord::Base.transaction do
      # 既存の画像を確認
      existing_image = @book.images.find_by(page_number: page_number)
      if existing_image.present?
        unless ActiveModel::Type::Boolean.new.cast(params[:image][:overwrite])
          render json: { error: 'Image already exists' }, status: :conflict
          next
        end

        existing_image.image.purge # 既存の画像を削除
        existing_image.destroy # imageのカラムも削除

      end

      # 新しい画像を保存
      image = @book.images.build(page_number: page_number)
      image.image.attach(uploaded_file)
      if image.save
        render json: image, status: :created
      else
        render json: image.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def image_params
    params.require(:image).permit(:page_number, images: []).merge(book_id: params[:book_id])
  end

  # ファイル名からページ番号を抽出
  def extract_page_number(filename)
    filename.split('.').first
  end
end
