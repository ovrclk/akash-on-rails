class Pin < ApplicationRecord
  include PinUploader::Attachment(:image)
end
