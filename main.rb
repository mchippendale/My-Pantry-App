require 'sinatra' 
require 'sinatra/reloader' if development?
require 'bcrypt'
require 'pry' if development?

require_relative 'db/helper.rb'

enable :sessions

def current_user

  if session[:user_id] == nil
    return {}
  end

  return run_sql("SELECT * FROM users WHERE id = #{session[:user_id]};")[0]

end

def logged_in?
  
  if session[:user_id] == nil
    return false
  else
    return true
  end

end


get '/' do
  erb :index
end


get '/session' do
  erb :login
end


get '/session/signup' do
  erb :sign_up
end

post '/session/new-user' do
  
  password_digest = BCrypt::Password.create(params['password'])

  sql = "INSERT INTO users (email, password_digest) VALUES ($1, $2);"

  
  run_sql(sql, [
    params['email'],
    password_digest
  ])

  redirect '/session'

end


post '/session' do

  records = run_sql("SELECT * FROM users WHERE email = '#{params['email']}';")

  if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']

    logged_in_user = records[0]

    session[:user_id] = logged_in_user["id"]
    binding.pry

    redirect '/'

  else

    erb :login

  end

end


delete '/session' do

  session[:user_id] = nil
  redirect '/'

end


get '/items/:id' do

  user_id = session[:user_id].to_i
  res = run_sql("SELECT * FROM items WHERE user_id = #{user_id};")

  items = res.to_a

  erb :show_item, locals: { items: items }

end


get '/items/:id/new' do

  erb :new_item_form

end


post '/items/:id/new' do

  user_id = session[:user_id].to_i
  sql = "INSERT INTO items (name, image_url, comment, user_id) VALUES ($1, $2, $3, $4);"

  run_sql(sql, [
    params['name'],
    params['image_url'],
    params['comment'],
    user_id
  ])

  redirect "/items/:id"

end