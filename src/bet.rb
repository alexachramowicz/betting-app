# # Alex Achramowicz
# file: bet.rb

require 'sinatra'
require 'dm-core'
require 'dm-migrations'

enable :sessions

get '/bet' do 
  # halt(401, ‘Not Authorized’) unless session[:login]
  @user = User.get(session[:id])
  @title = "Betting Site"
  erb :bet
end


post '/bet' do

  bet = params[:bet].to_i
  guess = params[:guess].to_i
  temp_win = session[:win]
  temp_loss = session[:loss]
  temp_profit = session[:profit]

  # if bet < session[:profit]
  if bet < 1
    session[:message] = "Please provide a valid bet > 0"
  elsif guess > 6 || guess < 1
    session[:message] = "Please provide a valid guess between 1-6"
  else
    roll = rand(6) + 1
    if guess == roll # win
      session[:message] = "The die landed on #{roll}, you win #{10*bet} dollars!"
      session[:win] = temp_win + (10*bet)
      session[:profit] = temp_profit + (10*bet)
    else # lose
      session[:message] = "The die landed on #{roll}, you lose #{bet} dollars."
      session[:loss] = temp_loss + bet
      session[:profit] = temp_profit - bet
    end
  end
  redirect to('./bet')
end


not_found do
  @title = "page not found"
  "Error URL undefined (no such route handler is defined)"
end