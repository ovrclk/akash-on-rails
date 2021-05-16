# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find_or_create_by(uid: 'auth0|609afb21a0b0bb006ad8c662') do |user|
  user.nickname = 'tom'
  user.admin = true
end

if ENV['PETFINDER_KEY'] && ENV['PETFINDER_SECRET']
  Pin.destroy_all

  petfinder = Petfinder::Client.new(ENV['PETFINDER_KEY'], ENV['PETFINDER_SECRET'])

  dogs = petfinder.animals(type: 'dog', limit: 100).first
  cats = petfinder.animals(type: 'cat', limit: 100).first
  count = 0
  (dogs + cats).shuffle.each do |animal|
    next unless animal.photos.any?

    name = animal.name =~ /\d/ ? nil : animal.name.presence
    description = Nokogiri::HTML.parse(CGI::unescapeHTML(animal.description)).text if animal.description.present?
    user.pins.create(
      title: [name, animal.breeds&.primary.presence].compact.join(' - '),
      description: description,
      image_remote_url: animal.photos.first.full,
      link: animal.url
    )
    count += 1

    break if count >= 100
  end
end
