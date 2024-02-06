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

  def upload
    # 上書きフラグがtrueの場合、既存の画像は削除してから画像保存処理へ
    overwrite = params[:overwrite] == "true"
    if overwrite && existing_image
      existing_image.image.purge # 既存の画像を削除
    end

    # ファイル情報を受け取り、保存処理を行う
    page_number = params[:page_number]
    book_id = params[:bookId]
    uploaded_file = params[:file]

    # 保存処理
    if page_number.present? && book_id.present? && uploaded_file.present?
      image = Image.new(book_id: book_id, page_number: page_number)
      image.image.attach(uploaded_file)

      if image.valid? && image.save
        render json: { message: "ファイルが正常にアップロードされました。" }, status: :ok
      else
        render json: { error: "ファイルの保存に失敗しました。" }, status: :unprocessable_entity
      end
    else
      render json: { error: "ファイル情報が不足しています。" }, status: :unprocessable_entity
    end
  end

  def create
    book_id = image_params[:book_id]
    uploaded_images = params[:image][:images].reject(&:blank?)
    saved_images_count = 0

    if saved_images_count == uploaded_images.size
      redirect_to book_path(book_id), notice: '登録が完了しました'
    else
      flash.now[:alert] = "#{uploaded_images.size - saved_images_count}件の画像の登録に失敗しました。"
      @image = Image.new
      @book_id = book_id
      render :new, status: :unprocessable_entity
    end
  end

  private

  def image_params
    params.require(:image).permit(:page_number, images: []).merge(book_id: params[:book_id])
  end
end
