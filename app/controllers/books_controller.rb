class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.includes(:images).find(params[:id])
    @book = Book.includes(:images).where(id: params[:id])
                .order('images.page_number ASC')
                .references(:images).first
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
