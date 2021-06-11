require 'sinatra' 
require 'bcrypt'
require 'cloudinary'
require 'pry' if development?
require 'sinatra/reloader' if development?


require_relative 'db/helper.rb'

# include CloudinaryHelper

enable :sessions

options = {
  cloud_name: "sei44", 
  api_key: ENV['CLOUDINARY_API_KEY'],
  api_secret: ENV['CLOUDINARY_API_SECRET_KEY']
}

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

  items = run_sql("SELECT * FROM users;")
  random_user_id(items)

  sql_1 = "SELECT name, image_url, username, image_upload, user_id FROM items WHERE user_id = #{random_user_id(items)};"
  sql_2 = "SELECT name, image_url, username, image_upload, user_id FROM items WHERE user_id = #{random_user_id(items)};"
  sql_3 = "SELECT name, image_url, username, image_upload, user_id FROM items WHERE user_id = #{random_user_id(items)};"
  sql_4 = "SELECT name, image_url, username, image_upload, user_id FROM items WHERE user_id = #{random_user_id(items)};"

  pantry1 = run_sql(sql_1)

  pantry2 = run_sql(sql_2)

  pantry3 = run_sql(sql_3)

  pantry4 = run_sql(sql_4)

  erb :index, locals: { pantry1: pantry1, pantry2: pantry2, pantry3: pantry3, pantry4: pantry4 }

  
end

get '/items/:id' do

  items = run_sql("SELECT name, image_url, username, image_upload, comment FROM items WHERE user_id = #{params['id']};")
  erb :show_pantry, locals: { items: items}

end


get '/session' do
  erb :login
end


get '/session/signup' do
  erb :sign_up
end

post '/session/new-user' do
  
  password_digest = BCrypt::Password.create(params['password'])

  sql = "INSERT INTO users (email, username, password_digest) VALUES ($1, $2, $3);"

  
  run_sql(sql, [
    params['email'],
    params['username'],
    password_digest
  ])

  redirect '/session'

end


post '/session' do

  records = run_sql("SELECT * FROM users WHERE email = '#{params['email']}';")

  if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']

    logged_in_user = records[0]

    session[:user_id] = logged_in_user["id"]

    redirect '/'

  else

    erb :login

  end

end


delete '/session' do

  session[:user_id] = nil
  redirect '/'

end


get '/session/:id' do

  user_id = session[:user_id].to_i
  res = run_sql("SELECT * FROM items WHERE user_id = #{user_id};")

  items = res.to_a

  erb :show_my_items, locals: { items: items }

end

delete '/session/:id/delete' do
  # if !logged_in?
  #   redirect '/login'
  # end

  # redirect '/login' unless logged_in? # syntactic sugar 
  user_id = session[:user_id].to_i
  sql = run_sql("DELETE FROM items WHERE id = #{params['id']};")

  redirect "/session/#{user_id}"

end

get '/items/:id/new' do

  erb :new_item_form

end

get '/items/:id/edit' do
  
  res = run_sql("SELECT * FROM items WHERE id = #{params['id']}")
  items = res[0]
  erb :edit_item_form, locals: { items: items}

end

put '/items/:id/edit' do

  image_upload = ""

  if params["image_upload"] 
    res = Cloudinary::Uploader.upload(params["image_upload"]['tempfile'], options)
    image_upload = res['url']
  end

  user_id = session[:user_id].to_i
  sql = "UPDATE items SET name = $1, image_url = $2, image_upload = $3, comment = $4, user_id = $5 WHERE id = #{params['id']};"

  run_sql(sql,  [
    params['name'],
    params['image_url'],
    image_upload,
    params['comment'],
    user_id
  ])

  redirect "/items/#{user_id}"

end


post '/items/:id/new' do
  image_upload = ""

  user_id = session[:user_id].to_i
  user = run_sql("SELECT username FROM users WHERE id = #{user_id}")[0]
  username = user['username']
  
  if params["image_upload"]
    res = Cloudinary::Uploader.upload(params["image_upload"]['tempfile'], options)
    image_upload = res['url']
  end

  sql = "INSERT INTO items (name, image_url, comment, user_id, username, image_upload) VALUES ($1, $2, $3, $4, $5, $6);"

  run_sql(sql, [
    params['name'],
    params['image_url'],
    params['comment'],
    user_id,
    username,
    image_upload,
  ])

  redirect "/items/#{user_id}"

end



#NOTES

    # display each users items in seperate lists. 
    # orderby...the user_id
    # groupby...
    # postgresqltutorial.com 
    # transpose row content
    # how do I turn and entry (a column value) create to columns 
    # testimonial - scroll across the screen 
    # separate queries, view 'more' detail on each pantries. 

    # generate 3 feature pantries - first generate a report to show the distinct user_id's, however many uses. Array of the length of users. 
    # sample the array of users, checking the previosu sample isn't the same number. 
