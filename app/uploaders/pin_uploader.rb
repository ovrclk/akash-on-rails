class PinUploader < Shrine
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)

    {
      large: magick.resize_to_fill!(800, 800),
      medium: magick.resize_to_fill!(500, 500),
      small: magick.resize_to_fill!(300, 300)
    }
  end
end
