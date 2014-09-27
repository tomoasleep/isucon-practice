# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'isucon_practice'
set :repo_url, 'git@github.com:tomoasleep/isucon-practice.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/isu-user/isucon-repo'

# Default value for :scm is :git
set :scm, :git

# Ask branch to deploy
set :branch, ask('branch to deploy', 'master')

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# Need enable to run `sudo`
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :bundle_gemfile, -> { release_path.join('webapp/ruby/Gemfile') }
set :bundle_path, -> { release_path.join('webapp/ruby/vendor/bundle') }

desc 'Test task'
task :test do
  on roles(:web) do
    execute :who
    execute :pwd
    execute :sudo, :who
  end
end

# task :initialize do
#   on roles(:init) do
#     execute :sudo, :cp, '-r /home/ec2-user/.ssh /home/isu-user/.ssh'
#     execute :mkdir, '/home/isu-user/shared'
#     execute :cp, release_path.join('bench/data'), '~/shared/init.sql.gz'
#     execute :cp, release_path.join('bench')     , '~/shared/cpanfile.snapshot'
#     execute :cp, release_path.join('bench')     , '-r ~/shared/local'
#     execute :sudo, :chmod, 'isu-user -R /home/isu-user/.ssh'
#     execute :sudo, :chmod, 'isu-user -R /home/isu-user/shared'
#   end
# end
# 
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      within release_path.join('bench') do
        execute :cp, '~/shared/init.sql.gz', release_path.join('bench/data')
        # execute :carton, 'install'
        execute :cp, '~/shared/cpanfile.snapshot', release_path.join('bench')
        execute :cp, '-r ~/shared/local', release_path.join('bench')
        execute :go, 'build', '-o', release_path.join('bench/bench')
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
      execute :sudo, 'supervisorctl reload'
      # execute :sudo, 'supervisorctl restart isucon_ruby'
    end
  end

end
