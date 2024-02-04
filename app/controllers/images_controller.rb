class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to books_path(@image.book.id), notice: '登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def image_params
    params.require(:image).permit(:page_number, :image).merge(book_id: book.id)
  end
end
