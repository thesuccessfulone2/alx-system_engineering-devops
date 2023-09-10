# Install and configure haproxy
class { 'haproxy':
  global_options => {
    'log' => '127.0.0.1 local0 notice',
    'maxconn' => '2000',
    'user' => 'haproxy',
    'group' => 'haproxy',
  },
  defaults_options => {
    'log' => 'global',
    'mode' => 'http',
    'option' => ['httplog', 'dontlognull'],
    'retries' => '3',
    'timeout connect' => '5000',
    'timeout client' => '10000',
    'timeout server' => '10000',
  },
}

# Define frontend and backend sections
haproxy::frontend { 'http-in':
  ipaddress => '*',
  ports     => '80',
  options   => {
    # Set custom HTTP header with hostname of nginx server
    http-request => "set-header X-Served-By % [ssl_fc_sni]",
    default_backend => "webservers",
  },
}

haproxy::backend { 'webservers':
  options   => {
    balance     => "roundrobin",
  },
}

# Add web servers to backend section
haproxy::balancermember { "web-01":
  listening_service => "webservers",
  server_names      => "web-01",
  ipaddresses       => "34.227.101.223",
  ports             => "80",
  options           => "check",
}

haproxy::balancermember { "web-02":
  listening_service => "webservers",
  server_names      => "web-02",
  ipaddresses       => "54.162.236.122",
  ports             => "80",
  options           => "check",
}
