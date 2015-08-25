require 'rtesseract'
require 'rmagick'


image = RTesseract.new("/Users/mdidato/Projects/Personal/shootme/lib/Take a screenshot/ie_7.0.jpg")
puts image.to_s