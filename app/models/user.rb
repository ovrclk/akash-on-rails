class User < ApplicationRecord
  has_many :pins, dependent: :destroy

  validates :uid, :nickname, presence: true

  before_save :set_first_admin

  private

  def set_first_admin
    return if User.where(admin: true).where.not(uid: 'akash').any?

    self.admin = true
  end
end
