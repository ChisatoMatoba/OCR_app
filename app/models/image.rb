class Image < ApplicationRecord
  belongs_to :book
  has_one :text, dependent: :destroy
  has_one_attached :image

  with_options presence: true do
    validates :content
    validates :fixed_content
  end
end
