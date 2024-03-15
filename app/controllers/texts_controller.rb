class TextsController < ApplicationController
  def new
    @text = Text.new
    @image = Image.find(params[:image_id])
  end

  def create
    @text = Text.new(text_params)
    @image = Image.find(params[:image_id])

    image_blob = @image.image.blob
    image_url = Rails.application.routes.url_helpers.rails_blob_url(image_blob, only_path: true)

    image_rtesseract = RTesseract.new(image_url, lang: 'jpn')
    @text.content = image_rtesseract.to_s
    if @text.save
      redirect_to book_text_path(text), notice: '文字変換が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def text_params
    params.require(:text).permit(:content, :fixed_content).merge(book_id: params[:book_id], image_id: params[:image_id])
  end
end
