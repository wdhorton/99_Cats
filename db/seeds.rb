# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Cat.destroy_all



5.times do |i|
  Cat.create!(
              birth_date: Date.current,
              color: Cat::CAT_COLOR.sample,
              name: "Cat #{i}",
              sex: ["M", "F"].sample,
              description: "Description of Cat #{i}."
              )
end

4.times do |i|
  CatRentalRequest.create!(
                            cat_id: Cat.first.id,
                            start_date: Date.new(2015, 1 + i, 1),
                            end_date: Date.new(2015, 1 + i, 3)
                          )
end

Cat.all.each do |cat|
  cat.cat_rental_requests.create!(start_date: Date.new(2014, 1, 1), end_date: Date.new(2014, 1, 3))
end
