# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

CSV.foreach('db/ownerships_data_to_register.csv') do |row|
  p row[0]
  Ownership.create(:type => row[0], :user_id => row[1], :item_id => row[2])
  
end