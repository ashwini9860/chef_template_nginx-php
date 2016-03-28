#
# Cookbook Name:: gatest
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "date" do
command "apt-get update -y"
end
package "nginx" do
action :install
end
service "nginx" do
action [:enable, :start]
end

template "/etc/nginx/sites-available/default" do
source "vhost.erb"
variables({
	:doc_root => node['gatest']['doc_root'],
	:server_name => node['gatest']['server_name']
	})
action :create
notifies :restart, resources(:service => "nginx")
end
package "php5-fpm" do
action :install
end
file "/usr/share/nginx/html/index.php" do
content "<?php
phpinfo();
?>"
mode "0755"
owner "root"
group "root"
end
