require 'sinatra'
require 'sinatra/reloader'

configure do
  enable :sessions
  set :session_secret, 'something'
end

def assign_dollars
  session[:dollars] = 5 unless session[:dollars]
end

get '/' do
  assign_dollars

  redirect '/broke' if session[:dollars] <= 0

  erb :form
end

post '/' do
  guess = params[:guess].to_i
  rand_number = [1, 2, 3].sample
  bet = params[:bet].to_i
  if !(1..session[:dollars]).cover?(bet)
    session[:message] = "You have to bet between 1 and #{session[:dollars]}"
    redirect '/'
  end

  if guess == rand_number
    session[:message] = 'You have guessed correctly'
    session[:dollars] += bet
  else
    session[:message] = "You guessed #{guess} while the number was #{rand_number}"
    session[:dollars] -= bet
  end

  redirect '/'
end

get '/broke' do

  erb :broke, layout: :layout
end