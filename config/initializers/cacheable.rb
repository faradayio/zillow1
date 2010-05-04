servers = [ 'localhost:11211' ]
options = {
  :support_cas => true,
  :binary_protocol => true,             # Use the binary protocol to reduce query processing overhead. Defaults to false.
  :connect_timeout => 5,                # How long to wait for a connection to a server. Defaults to 2 seconds. Set to 0 if you want to wait forever.
  :timeout => 0.25,                     # How long to wait for a response from the server. Defaults to 0.25 seconds. Set to 0 if you want to wait forever.
  :server_failure_limit => 25           # How many consecutive failures to allow before marking a host as dead. Has no effect unless :retry_timeout is also set. Defaults to 2
}
Cacheable.repository = Memcached.new servers, options
