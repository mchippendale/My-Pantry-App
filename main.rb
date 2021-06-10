require 'sinatra' 
require 'sinatra/reloader' if development?
require 'bcrypt'
require 'pry' if development?
require 'cloudinary'


require_relative 'db/helper.rb'

# include CloudinaryHelper

enable :sessions

options = {
  cloud_name: "sei44", 
  api_key: "316847847996641",
  api_secret: "tUYkY7iicu4V4eI5i9s9RcJZ_xo"
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

  sql_1 = "SELECT name, image_url, username, image_upload FROM items WHERE user_id = #{random_user_id(items)};"
  sql_2 = "SELECT name, image_url, username, image_upload FROM items WHERE user_id = #{random_user_id(items)};"
  sql_3 = "SELECT name, image_url, username, image_upload FROM items WHERE user_id = #{random_user_id(items)};"
  sql_4 = "SELECT name, image_url, username, image_upload FROM items WHERE user_id = #{random_user_id(items)};"

  pantry1 = run_sql(sql_1)

  pantry2 = run_sql(sql_2)

  pantry3 = run_sql(sql_3)

  pantry4 = run_sql(sql_4)

  erb :index, locals: { pantry1: pantry1, pantry2: pantry2, pantry3: pantry3, pantry4: pantry4 }

  
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


get '/items/:id' do

  user_id = session[:user_id].to_i
  res = run_sql("SELECT * FROM items WHERE user_id = #{user_id};")

  items = res.to_a

  erb :show_item, locals: { items: items }

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

  user_id = session[:user_id].to_i
  sql = "UPDATE items SET name = $1, image_url = $2, comment = $3, user_id = $4 WHERE id = #{params['id']}"

  run_sql(sql,  [
    params['name'],
    params['image_url'],
    params['comment'],
    user_id
  ])

  redirect "/items/#{session[:user_id]}"

end


post '/items/:id/new' do

  user_id = session[:user_id].to_i

  res = Cloudinary::Uploader.upload(params["image_upload"]['tempfile'], options)
  binding.pry

  image_upload = res['url']
  sql = "INSERT INTO items (name, image_url, comment, user_id, image_upload) VALUES ($1, $2, $3, $4, $5);"

  run_sql(sql, [
    params['name'],
    params['image_url'],
    params['comment'],
    user_id,
    image_upload
  ])

  redirect "/items/:id"

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
