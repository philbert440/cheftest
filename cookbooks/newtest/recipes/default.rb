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

bash 'nginx_changes' do
  user 'root'
  code <<-EOH
  sudo sed -i '54,58 s/#/ /' /etc/nginx/sites-available/default
  sudo sed -i '60,64 s/#/ /' /etc/nginx/sites-available/default
  EOH
end

template '/etc/nginx/sites-available/default' do
  source 'sitefile.erb'
end