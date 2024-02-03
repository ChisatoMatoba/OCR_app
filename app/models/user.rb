class User < ApplicationRecord
  has_many :books, dependent: :nullify

  with_options presence: true do
    validates :login_name
    validates :password_digest
  end
end
