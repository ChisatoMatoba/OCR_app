class TextsController < ApplicationController
  def new
    @text = Text.new
    @image = Image.find(params[:image_id])
  end

  def create
    @image = Image.find(params[:image_id])

    # Active Storageから画像を取得して一時ファイルに保存
    download_blob_to_tempfile(@image.image.blob) do |tempfile|
      # RTesseractを使って一時ファイルからテキストを抽出
      image_rtesseract = RTesseract.new(tempfile.path, lang: 'jpn')
      extracted_text = image_rtesseract.to_s
      @text = Text.new(content: extracted_text, book_id: params[:book_id], image_id: params[:image_id])

      if @text.save
        redirect_to book_path(@text.book_id), notice: '文字変換が完了しました'
      else
        redirect_to book_path(@text.book_id), status: :unprocessable_entity
      end
    end
  end

  private

  def text_params
    params.require(:text).permit(:content, :fixed_content).merge(book_id: params[:book_id], image_id: params[:image_id])
  end

  # Active StorageのBlobを一時ファイルとしてダウンロード
  def download_blob_to_tempfile(blob)
    tempfile = Tempfile.new([blob.filename.to_s, blob.filename.extension_with_delimiter])
    tempfile.binmode
    tempfile.write(blob.download)
    tempfile.rewind
    yield(tempfile)
  ensure
    tempfile.close
    tempfile.unlink # 一時ファイルを削除
  end
end
