worker_processes 2
working_directory "/root/zfswrapper/"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 30

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "/tmp/.sock", :backlog => 64

pid "/root/zfswrapper/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "/root/zfswrapper/log/unicorn.stderr.log"
stdout_path "/root/zfswrapper/log/unicorn.stdout.log"
