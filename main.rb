
%w( rubygems date sinatra/base haml ).each { |f| require f }

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
			request.cookies["test"] == '51d6d976913ace58'
		end

		def auth
			stop [ 401, 'Not authorized' ] unless admin?
		end
	end

	#layout 'default'

	### Public

	get '/' do
		zfs = ZFS.list
		haml :index, :locals => { :zfs => zfs }, :layout => :default
	end

  get '/snapshots' do
    zfs = ZFS.list :snapshot
    haml :snapshots, :locals => { :zfs => zfs}, :layout => :default
  end

  get '/props/*' do
    zf = params['splat'][0]
    zp = ZFS.prop(zf)
    haml :props, :locals => { :zprops => zp[zf]}, :layout =>:default
  end

  get '/snap/*' do
    zf = params['splat'][0]
    ZFS.snap(zf)
    redirect '/snapshots'
  end

  get '/clone/*' do
    sn = params['splat'][0]
    haml :clone, :locals => { :snap => sn}, :layout => :default
  end

  post '/clone/*' do
    puts sn = params['splat'][0]
    puts newname = params[:clone]
    ZFS.clone(sn, sn.split(/\/|@/)[0] + "/" + newname)
    redirect '/'
  end

  get '/destroy/*' do
    ZFS.destroy(params['splat'][0])
    redirect '/snapshots'
  end

  get '/rollback/*' do
    ZFS.rollback(params['splat'][0])
    redirect '/snapshots'
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

