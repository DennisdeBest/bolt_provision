set :application, 'dev.france-crypto'
set :repo_url, 'git@github.com:DennisdeBest/bolt_provision.git'

# To make safe to deplyo to same server
set :tmp_dir, "/tmp/dev-france-crypto"

set :deploy_to, '/var/www/dev.france-crypto.com'

fetch(:default_env).merge!(PATH: '$PATH:/opt/php-7.0.1/bin/php')
# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('app/config/config.yml')
#set :linked_files, %w(app/config/parameters.yml project/app/config/parameters.yml)
# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('var')
# Dirs that need to be writable by the HTTP Server (i.e. cache, log dirs)
set :file_permissions_paths,['var/']

# Name used by the Web Server (i.e. www-data for Apache)
set :file_permissions_users, ['www-data']
set :webserver_user, "www-data"
set :file_permissions_paths, ["app/cache"]
set :file_permissions_users, ["www-data"]

# Name used by the Web Server (i.e. www-data for Apache)
set :controllers_to_clear, [""]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :composer_install_flags, -> { "--no-interaction --optimize-autoloader --working-dir=#{fetch(:release_path)}" }
SSHKit.config.command_map[:composer] = "/opt/php-7.0.1/bin/php /usr/local/bin/composer"
SSHKit.config.command_map[:php] = "/opt/php-7.0.1/bin/php"

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
         execute :rake, 'cache:clear'
    end
  end

end
