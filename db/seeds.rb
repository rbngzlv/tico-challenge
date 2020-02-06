# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Profile.create!(
  name: "Mexican Burrito",
  address: "Town Street, 25",
  lat: -85.6889,
  lng: 120.5895,
  closed: true
)

unless Platform.any?
  Platform.create!([
                     { kind: "type_a", api_key: "4fb6c9ee385f3b803bd05f9638d52908", extra_fields: { category_id: 1500 } },
                     { kind: "type_b", api_key: "4fb6c9ee385f3b803bd05f9638d52908", extra_fields: { category_id: 2010 } },
                     { kind: "type_c", api_key: "4fb6c9ee385f3b803bd05f9638d52908", extra_fields: { address_line_2: "" } }
                   ])
end
