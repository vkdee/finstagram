helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
    @vee_posts = VeePost.order(created_at: :desc)
   # @current_user = User.find_by(id: session[:user_id])

  erb(:index)
end

#-------------------LIKES
# Assign values from params to variables.
# Create a new 'Like` record with those values.
# Assign the like to the current_user.
# Save the like.
# Redirect the user back to wherever they came from 
#(remember that users can like finstagram posts on both the "/" and "/finstagram_posts/:id" pages).

post '/likes' do
  #params.to_s
  post_id = params[:vee_post_id]

  like = Like.new({ vee_post_id: post_id, user_id: current_user.id })
  like.save

  redirect(back)
end

delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

#-------------------COMMENTS



post '/comments' do
  
  # params.to_s

  # point values from params to variables
  text = params[:text]
  post_id = params[:vee_post_id]

  # instantiate a comment with those values & assign the comment to the `current_user`
  comment = Comment.new({ text: text, vee_post_id: post_id, user_id: current_user.id })

  # save the comment
  comment.save

  # `redirect` back to wherever we came from
  redirect(back)
end

#-------------------POSTS

get '/vee_posts/new' do
  @vee_post = VeePost.new

  erb(:"vee_posts/new")
end


post '/vee_posts' do
  photo_url = params[:photo_url]

  # instantiate new Post
  @vee_post = VeePost.new({ photo_url: photo_url, user_id: current_user.id })


  # if @post validates, save
  if @vee_post.save
    redirect(to('/'))
  else

    # if it doesn't validate, print error messages
    erb(:"vee_posts/new")

  end
end


get '/vee_posts/:id' do
  #params[:id]
  @vee_post = VeePost.find(params[:id])   # find the finstagram post with the ID from the URL
  #escape_html @vee_post.inspect        # print to the screen for now
  erb(:"vee_posts/show")               # render app/views/finstagram_posts/show.erb

end



#--------------------- LOGIN


get '/login' do    # when a GET request comes into /login
  erb(:login)      # render app/views/login.erb
end



post '/login' do
  username = params[:username]
  password = params[:password]

  @user = User.find_by(username: username)  

  if @user && @user.password == password
    session[:user_id] = @user.id
    "Success! " + username + " User with id #{session[:user_id]} is logged in"
    #erb(:index)
        redirect to('/')

  else
    @error_message = "Login failed."
    erb(:login)
  end
end

get '/logout' do
  session[:user_id] = nil
          redirect to('/')

end


#------------------  SIGN UP 

get '/signup' do

  @user = User.new
  erb(:signup)   # returns an entire document  erb is a method --- or is it an object? 

end


post '/signup' do

    # grab user input values from params
    email      = params[:email]
    avatar_url = params[:avatar_url]
    username   = params[:username]
    password   = params[:password]


    # instantiate and save a User
    @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })
   
    if @user.save
        erb(:login)
    else
        erb(:signup)
    end

end

