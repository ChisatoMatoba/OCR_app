class ImagesController < ApplicationController
  def new
    @image = Image.new
    @book_id = params[:book_id]
  end

  def create
    book_id = image_params[:book_id]
    uploaded_images = params[:image][:images].reject(&:blank?)
    saved_images_count = 0

    uploaded_images.each do |file|
      if file.respond_to?(:original_filename)
        page_number = File.basename(file.original_filename, '.*')
        image = Image.new(book_id: book_id, page_number: page_number)
        image.image.attach(file)
        image.save
        saved_images_count += 1 if image.save
      end
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
end
