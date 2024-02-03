class Book < ApplicationRecord
  belongs_to :user
  has_many :images, dependent: :destroy

  with_options presence: true do
    validates :book_name
    validates :status
  end

  enum status: {
    not_started: 0,
    in_progress: 1,
    completed: 2
  }
end
