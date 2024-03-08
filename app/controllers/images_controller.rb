class ImagesController < ApplicationController
  def index
    @images = Image.includes(:book).all
  end

  def new
    @image = Image.new
    @book = Book.find_by(id: params[:book_id])
  end

  def check_existence
    data = JSON.parse(request.body.read)
    book_id = params[:book_id]
    page_number = data['page_number']
    book = Book.find_by(id: book_id)
    image_exists = book.images.exists?(page_number: page_number)
    render json: { exists: image_exists }
  end

  def create
    book_id = params[:book_id]
    @book = Book.find_by(id: book_id)
    uploaded_images = image_params[:images].compact_blank
    saved_images_count = 0

    uploaded_images.each do |uploaded_file|
      page_number = extract_page_number(uploaded_file.original_filename)
      existing_image = @book.images.find_by(page_number: page_number)

      # クライアントサイドからの上書きフラグを確認
      if params[:overwrite] == true
        if existing_image.present?
          existing_image.image.purge # 既存の画像を削除
        end
        # 新しい画像を保存
      elsif existing_image.present?
        next
      end
      # 上書きしない場合、既存の画像があればスキップ

      # 新しい画像を保存
      image = @book.images.build(page_number: page_number)
      image.image.attach(uploaded_file)
      saved_images_count += 1 if image.save
    end

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

  # ファイル名からページ番号を抽出
  def extract_page_number(filename)
    filename.split('.').first
  end
end
