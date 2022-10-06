require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'haml'
require 'pony'

# configure do
#   enable :sessions
# end

# helpers do
#   def username
#     session[:identity] ? session[:identity] : 'Hello stranger'
#   end
# end

# before '/secure/*' do
#   unless session[:identity]
#     session[:previous_url] = request.path
#     @error = 'Sorry, you need to be logged in to visit ' + request.path
#     halt erb(:login_form)
#   end
# end

def under_construction
  @title = "Under Construction"
  @message = "This page is under construction"
  haml :message
end

get '/slim' do
  slim :slim
end

post '/slim' do
  slim <<-EOF
        h1= params[:file][:tempfile].path
        h1= params[:file][:filename]
      EOF
end


get '/' do
  under_construction
end

get '/about' do
  @title = "О нас"
  @message = "Информация о наших услугах"
  haml :about
end

get '/contact' do
  haml :contact
end

post '/contact' do

  @name = params[:name]
  @mail = params[:mail]
  @subject = params[:subject]
  @body = params[:body]
  @file_path = params[:file][:tempfile]
  @file_name = params[:file][:filename]

  Pony.mail(
    from:     @mail,
    to:       'danil-a@mail.ru',
    subject:  "#{@name} - #{@mail} - #{@subject}",
    body:     @body,
    html_body: "<h1>#{@name} - #{@mail}</h1><p>#{@body}</p>",
    attachments: {@file_name => File.read(@file_path)},
    via:      :smtp,

    via_options: { 
      :address              => 'smtp.gmail.com', 
      :port                 => '587', 
      :enable_starttls_auto => true, 
      :user_name            => 'designstudions@gmail.com', 
      :password             => 'omdsuzkwqruenliw', 
      :authentication       => :plain,
      :domain               => "localhost.localdomain"
    }
  )

  @title = "Thank you!"
  @message = "Уважаемый #{@name}, письмо отправлено, ответ пришлем на адрес #{@mail}"

  haml :message

end

get '/visit' do
  haml :visit
end

post '/visit' do
  @visit = {}
  @visit[:username] = params[:username]
  @visit[:phone] = params[:phone]
  @visit[:time] = params[:time]
  @visit[:barber] = params[:barber]
  @visit[:color] = params[:color]

  hh = {
    username: 'Введите имя',
    phone: 'Введите телефон',
    time: 'Введите дату и время'
  }

  @error = hh.select { |key,_| params[key] == ""}.values.join(', ')

  if @error != ""
    return haml :visit
  end

  File.open('./public/users.txt', 'a+') do |file|
    file.write "#{@visit[:username]} - "
    file.write "#{@visit[:phone]} - "
    file.write "#{@visit[:barber]} - "
    file.write "#{@visit[:time]} - "
    file.write "#{@visit[:color]}\n"
  end

  @title = "Thank you!"
  @message = "Уважаемый #{@visit[:username]}, мы ждём вас в #{@visit[:time]}"

  haml :message

end

get '/admin' do
  @title = "Страница входа"
  @message = "Введите вашу почту и пароль"
  haml :login
end

post '/admin' do
  @username = params[:username]
  @password = params[:password]

  if @username == "mail@mail.ru" && @password == "qwerty"
    
    @file = File.open "./public/users.txt", "r"
    @title = "Список записей"
    @message = "Данные по клиентам и время"
    haml :result

  else
    @title = "Доступ запрещен!"
    @message =  "Неправильный логин и пароль. Попробуйте еще раз!"
    haml :login
  end
end

# post '/login/attempt' do
#   session[:identity] = params['username']
#   where_user_came_from = session[:previous_url] || '/'
#   redirect to where_user_came_from
# end

# get '/logout' do
#   session.delete(:identity)
#   erb "<div class='alert alert-message'>Logged out</div>"
# end

# get '/secure/place' do
#   erb 'This is a secret place that only <%=session[:identity]%> has access to!'
# end
