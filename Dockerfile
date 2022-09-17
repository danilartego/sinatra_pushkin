FROM ruby:3.1.2
	
	#RUN git clone -q https://github.com/danilartego/sinatra_pushkin.git
	RUN mkdir sinatra_pushkin
	WORKDIR sinatra_pushkin
	COPY . .
	RUN gem install puma
	RUN gem install reel
	RUN gem install webrick
	RUN bundle install
	EXPOSE 4567
	CMD ["ruby", "app.rb"]