class User < ApplicationRecord
  has_many :pins, dependent: :destroy

  validates :uid, :nickname, presence: true
end
