# Initial environment
package("language-pack-es")

# VMX inner domain resolution
template "/etc/hosts" do
  source "etc_hosts"
  mode 00644
  owner "root"
  group "root"
  variables(
    :ip => node['ocax']['host_ip'],
    :host_name => node['ocax']['host_name'],
    :ocax_virtualhost => node['ocax']['virtualhost_name'] + '.' + node['ocax']['host_name'],
  )
end

# Setup a LAMP environment
include_recipe "apache2"
include_recipe "apache2::mod_php5"

service "apache2" do
  action :enable
end

include_recipe "mysql::client"
include_recipe "mysql::server"
include_recipe "database::mysql"

package("php5")
package("libapache2-mod-php5")
package("php5-curl")
package("php5-mysql")

# OCA(x) dependencies
package("memcached")
package("php5-memcache")
package("php-apc")
package("php5-mcrypt")
package("php5-imagick")
package("php5-gd")
package("unzip")

# Create installation directory
directory node["ocax"]["installpath"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

# Download and call unpack, only on the first provision
remote_file node[:ocax][:download_cache] do
  source node[:ocax][:download_url]
  mode 00644
  checksum node[:ocax][:download_checksum]
  notifies :run, "execute[Unpack ocax]", :immediately
end

# Unpack OCAx
execute "Unpack ocax" do
  cwd node["ocax"]["installpath"]
  command "tar --strip-components 1 -xzf #{node[:ocax][:download_cache]}"
  action :nothing
end

# Download Yii framework latest (ocax dependency)
remote_file node[:ocax][:yii_download_cache] do
  source node[:ocax][:yii_download_url]
  mode 00644
  checksum node[:ocax][:yii_download_checksum]
  notifies :run, "execute[Unpack yii]", :immediately
end

# Unpack Yii WARNING: Hardcoded!!!
execute "Unpack yii" do
  cwd '/tmp'
  command "tar xzf #{node[:ocax][:yii_download_cache]}; 
    rm -rf #{node[:ocax][:installpath]}/framework;
    mv /tmp/yii-1.1.14.f0fee9/framework #{node[:ocax][:installpath]}"
  action :nothing
end

# Setup apache virtual host
web_app 'ocax' do
  template 'site.conf.erb'
  server_name "#{node[:ocax][:virtualhost_name]}.#{node[:ocax][:host_name]}"
  docroot node['ocax']['installpath']+ '/app' # WARNING: Hardcoded!
end

# Set apache htaccess
bash "Set htaccess" do
  code <<-EOH
    cp #{node[:ocax][:installpath]}/app/htaccess #{node[:ocax][:installpath]}/app/.htaccess
  EOH
end

# Create mysql database and import scheme.sql file, using mysql root account
mysql_database "#{node[:ocax][:mysql_dbname]}" do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action [:create, :query]
  sql { ::File.open("#{node[:ocax][:installpath]}/schema.sql").read }
end

# Create mysql ocax-user grant privileges on database, create ocax admin account, using mysql root account
mysql_database_user "#{node[:ocax][:mysql_user]}" do
  connection    ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  password      "#{node[:ocax][:mysql_password]}"
  database_name "#{node[:ocax][:mysql_dbname]}"
  host          'localhost'
  action        [:grant, :query]
  sql "REPLACE INTO user (id, username, password, salt, email, is_active, is_admin) values (
    1, '#{node[:ocax][:adminaccount_username]}', 
    MD5('replace_this_salt_hash#{node[:ocax][:adminaccount_password]}'), 
    'replace_this_salt_hash',
    '#{node[:ocax][:adminaccount_email]}',
    1, 1)"
end

# Download data common to all Spanish OCMs
remote_file node[:ocax][:spanishbudget_download_cache] do
  source node[:ocax][:spanishbudget_download_url]
  mode 00644
  checksum node[:ocax][:spanishbudget_download_checksum]
end

# Import spanish budget
mysql_database "#{node[:ocax][:mysql_dbname]}" do
  connection ({:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']})
  action [:nothing, :query]
  sql { ::File.open("#{node[:ocax][:spanishbudget_download_cache]}").read }
end

#execute "Import spanish budget" do
#  command "mysql -u#{node[:ocax][:mysql_user]} -p#{node[:ocax][:mysql_password]} #{node[:ocax][:mysql_dbname]} < }"
#  action :nothing
#end

# Create config file
template "#{node[:ocax][:installpath]}/protected/config/main.php" do
  source "ocax_main.php"
  mode 00644
  owner "root"
  group "root"
  variables(
    :ocax_db_name => node['ocax']['mysql_dbname'],
    :ocax_db_username => node['ocax']['mysql_user'],
    :ocax_db_password => node['ocax']['mysql_password']
  )
end

# File permissions
directory "#{node[:ocax][:installpath]}/protected/runtime" do
  owner "www-data"
  group "www-data"
  recursive true
end

directory "#{node[:ocax][:installpath]}/app/assets" do
  owner "www-data"
  group "www-data"
  recursive true
end

directory "#{node[:ocax][:installpath]}/app/files" do
  owner "www-data"
  group "www-data"
  recursive true
end

# Run apache2 for first time
service "apache2 start" do
  service_name "apache2"
  action :start
end