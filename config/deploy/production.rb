# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

production_path = 'ec2-54-64-202-253.ap-northeast-1.compute.amazonaws.com'

# role :init, [path]
role :app,  [production_path]
role :web,  [production_path]
role :db,   [production_path]


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server production_path, user: 'isu-user', roles: %w{web app}, my_property: :my_value
# server 'ec2-54-64-202-253.ap-northeast-1.compute.amazonaws.com', user: 'ec2-user', roles: %w{init}, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
  keys: File.expand_path('~/.ssh/isucon-aws-practice.pem'),
  forward_agent: false
  #auth_methods: %w(password)
}
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
