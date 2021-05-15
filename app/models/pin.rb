class Pin < ApplicationRecord
  belongs_to :user, required: true

  include PinUploader::Attachment(:image)

  validates :title, :link, :image, presence: true
end
