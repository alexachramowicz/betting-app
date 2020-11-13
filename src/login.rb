# # Alex Achramowicz
# file: login.rb

require 'sinatra'
require 'dm-core'
require 'dm-migrations'

get '/create' do
  @title = "Betting Site Account Creation"
  erb :create
end


post '/create' do
  @users = User.all
  @users.each do |user|
    if user.username == params[:username]
      session[:message] = "Username already taken"
      redirect to("/create")
    end
  end

  @user = User.new
  @user.username = params[:username]
  @user.password = params[:password]
  @user.win = 0
  @user.loss = 0
  @user.profit = 0
  @user.save

  erb :login
end


get '/login' do
	@title = "Betting Site Login"
	if session[:login]
		redirect to("/bet")
	else
		erb :login
	end
end


post '/login' do
  @users = User.all
  @users.each do |user|
    if user.username == params[:username] && user.password == params[:password]
      session[:login] = true
      session[:id] = user.id

      session[:win] = 0
      session[:loss] = 0
      session[:profit] = 0

      redirect to("/bet")
    end
  end
  session[:message] = "Username or password don't match."
  redirect to ("/login")
end


get '/logout' do
  @user = User.get(session[:id])

  @user.update(win: @user.win + session[:win])
  @user.update(loss: @user.loss + session[:loss])
  @user.update(profit: @user.profit + session[:profit])

	session.clear
	session[:message] = "Results saved<br>Successfully logged out!"

	redirect to("/login")
end


not_found do
	@title = "page not found"
	"Error URL undefined (no such route handler is defined)"
end