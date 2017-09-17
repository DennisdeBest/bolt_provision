set :application, 'dev.france-crypto'
set :repo_url, 'git@github.com:DennisdeBest/bolt_provision.git'

set :tmp_dir, "/tmp/dev-france-crypto"

set :deploy_to, '/var/www/dev.france-crypto.com'

set :stages, ["staging", "production"]
set :default_stage, "staging"

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
#set :linked_files, fetch(:linked_files, []).push('project/app/config/config.yml')
#set :linked_files, %w(app/config/parameters.yml project/app/config/parameters.yml)
# Default value for linked_dirs is []
#set :linked_dirs, fetch(:linked_dirs, []).push('var')

#set :file_permissions_paths,['var/']

# Name used by the Web Server (i.e. www-data for Apache)
set :webserver_user, "www-data"

# Dirs that need to be writable by the HTTP Server (i.e. cache, log dirs)
#set :file_permissions_users, ['www-data']
set :file_permissions_paths,  ["project/public", "project/app/config/extensions", "project/app/cache", "project/theme"]
set :file_permissions_users, ["www-data"]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :composer_install_flags, -> { "--no-interaction --optimize-autoloader --working-dir=#{fetch(:release_path)}/project" }
SSHKit.config.command_map[:composer] = "/opt/php-7.0.1/bin/php /usr/local/bin/composer"
SSHKit.config.command_map[:php] = "/opt/php-7.0.1/bin/php"

after 'deploy:starting', 'composer:install_executable'
after 'deploy:cleanup', 'deploy:set_permissions:chown'

namespace :deploy do

  before 'deploy:set_permissions:check', 'create_cache_folder' do
    on roles(:web) do
      execute "mkdir #{release_path}/project/app/cache"
      execute "cp  #{shared_path}/project/app/config/config.yml #{release_path}/project/app/config/config.yml"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
         execute :rake, 'cache:clear'
    end
  end


 before :cleanup, :cleanup_permissions

  desc 'Set permissions on old releases before cleanup'
  task :cleanup_permissions do
    on release_roles :all do |host|
      releases = capture(:ls, '-x', releases_path).split
      if releases.count >= fetch(:keep_releases)
        info "Cleaning permissions on old releases"
        directories = (releases - releases.last(1))
        if directories.any?
          directories.each do |release|
            within releases_path.join(release) do
                execute :sudo, :chown, '-R', 'exploit', '/var/www/dev.france-crypto.com/releases'
            end
          end
        else
          info t(:no_old_releases, host: host.to_s, keep_releases: fetch(:keep_releases))
        end
      end
    end
  end

end
