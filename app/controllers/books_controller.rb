class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.eager_load(:images).find_by(id: params[:id])
    return render file: Rails.public_path.join('404.html').to_s, status: :not_found unless @book

    # 画像をページ番号の昇順で並べ替え、インスタンス変数に割り当てる
    @images = @book.images.order('page_number ASC')

    flash[:notice] = '登録が完了しました' if params[:notice].present?
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to root_path, notice: '登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:book_name, :status)
  end
end
