#
# Cookbook Name:: newtest
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
apt_package 'nginx'

service 'nginx' do
  action :start
end

apt_package 'php5-mysql'
apt_package 'php5-fpm'

bash 'phpini_changes' do
  user 'root'
  code <<-EOH
  sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php5/fpm/php.ini
  EOH
end

service 'php5-fpm' do
  action :restart
end

template '/etc/nginx/sites-available/default' do
  source 'sitefile.erb'
end

apt_package 'git'
apt_package 'drush'


bash 'pulling_drupal' do
  user 'root'
  cwd '/usr/share/nginx/html/'
  code <<-EOH
  git clone --branch 8.0.x http://git.drupal.org/project/drupal.git
  EOH
end
