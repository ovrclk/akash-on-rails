class User < ApplicationRecord

  validates :uid, :nickname, presence: true
end
