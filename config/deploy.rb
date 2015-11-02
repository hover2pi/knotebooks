set :application, "knotebooks"
set :domain, "knotebooks.com"

set :scm, :git
set :user, "deploy"
set :use_sudo, false
set :repository, "git@github.com:Unobtainium/knotebooks-rewrite.git"
set :branch, "master"
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
set :ssh_options, { :port => 28632, :forward_agent => true }
set :git_enable_submodules, 1

role :app, domain
role :web, domain
role :db, domain, :primary => true


set :deploy_to, "/home/deploy/apps/#{application}"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start, :roles => :app do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :setup do
  task :migrate do
    run "cd #{current_path} && rake db:migrate && rake db:seed && rake db:fixtures:load && rake ts:conf && rake ts:index"
  end
end

# From http://gist.github.com/188053
after "deploy:setup", "thinking_sphinx:shared_sphinx_folder"
after 'deploy:finalize_update', 'thinking_sphinx:symlink_indexes'
after 'deploy:restart', 'thinking_sphinx:restart'

namespace :thinking_sphinx do
  task :symlink_indexes, :roles => [:app] do
    run "ln -nfs #{shared_path}/db/sphinx #{latest_release}/db/sphinx"
  end
  task :restart do
    # configure
    god.app.delayed_delta.stop
    god.app.searchd.restart
    god.app.delayed_delta.start
  end
end

require 'san_juan'
 
san_juan.role :app, %w(delayed_delta searchd)


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
