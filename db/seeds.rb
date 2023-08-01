# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

# Create Users
TripAssignment.destroy_all
Trip.destroy_all
User.destroy_all
user1 = User.create!(email: 'user1@example.com', password: 'password1', username: 'TEST-USER-1')
user2 = User.create!(email: 'user2@example.com', password: 'password2', username: 'TEST-USER-2')
user3 = User.create!(email: 'user3@example.com', password: 'password3', username: 'TEST-USER-3')
user4 = User.create!(email: 'user4@example.com', password: 'password4', username: 'TEST-USER-4')
