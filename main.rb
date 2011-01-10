
%w( rubygems date sinatra/base haml ).each { |f| require f }

#$LOAD_PATH.unshift File.dirname(__FILE__) + '/vendor/sequel'

class ZFS_web < Sinatra::Base

	configure do
		set :views, File.join(File.dirname(__FILE__), 'views')
		set :run, false
		set :env, ENV['RACK_ENV']
	end

	error do
		e = request.env['sinatra.error']
		puts e.to_s
		puts e.backtrace.join("\n")
		"Application error"
	end

	$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
	require 'zpool'
	require 'zfs'

	helpers do
		def admin?
			request.cookies[Blog.admin_cookie_key] == Blog.admin_cookie_value
		end

		def auth
			stop [ 401, 'Not authorized' ] unless admin?
		end
	end

	layout 'layout'

	### Public

	get '/' do
		zfs = ZFS.list
		haml :index, :locals => { :zfs => zfs }, :layout => false
	end

	get '/post' do
	end

	### Admin

	get '/auth' do
		haml :auth
	end

	post '/auth' do
		response.set_cookie("test", "51d6d976913ace58") if params[:password] == "test"
		redirect '/'
	end

	get '/posts/new' do
		auth
		haml :edit, :locals => { :post => Post.new, :url => '/posts' }
	end

	post '/posts' do
		auth
		post = Post.new :title => params[:title], :tags => params[:tags], :body => params[:body], :created_at => Time.now, :slug => Post.make_slug(params[:title])
		post.save
		redirect post.url
	end

end
