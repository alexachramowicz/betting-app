# # Alex Achramowicz
# file: home.rb

require 'sinatra'
require './src/login'
require './src/bet'

configure :development do
	require 'sinatra/reloader'
	#setup sqlite database
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/user.db")
end

configure :production do 
	# setup postgres database
	DataMapper.setup(:default, ENV["DATABASE_URL"])
end

class User
  include DataMapper::Resource

  property :id, Serial
  property :username, Text
  property :password, Text
  property :win, Integer
  property :loss, Integer
  property :profit, Integer
end

DataMapper.finalize

enable :sessions

get '/' do 
	@title = "Betting Site Home Page"
	erb :home
end

not_found do
  @title = "page not found"
  "Error URL undefined (no such route handler is defined)"
end