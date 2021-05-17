class Pin < ApplicationRecord
  belongs_to :user, required: true

  include PinUploader::Attachment(:image)

  scope :recently_created, -> { order(created_at: :desc) }

  validates :title, :link, :image, presence: true
end
