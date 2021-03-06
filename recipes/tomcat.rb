#
# Cookbook:: tomcat
# Recipe:: tomcat
#
# Copyright:: 2018, The Authors, All Rights Reserved.

execute 'update' do
  command 'sudo apt-get update -y'
end
#Install oracle java8
apt_repository 'oracle-java8-installer' do
  uri 'http://ppa.launchpad.net/webupd8team/java/ubuntu'
  keyserver "keyserver.ubuntu.com"
  key 'EEA14886'
  distribution 'xenial'
  components ["main"]
  cache_rebuild true
  notifies :run,'execute[accept]', :immediately
end

#Accept java licence
execute 'accept' do
  command 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections'
  notifies :run,'execute[seen]', :immediately
  action :nothing
end

execute 'seen' do
  command 'echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections'
  action :nothing
end

package 'oracle-java8-installer'

#setup JAVA_HOME
append_if_no_line "set JAVA_HOME" do
  path "/etc/environment"
  line 'JAVA_HOME=/usr/lib/jvm/java-8-oracle'
end

#create tomcat user
user 'tomcat' do
  comment 'A tomcat user'
  home '/opt/tomcat'
  shell '/bin/false'
end

#create tomcat group
group 'tomcat' do
  action :create
  members 'tomcat'
end

#download and install tomcat
tar_extract 'http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34.tar.gz' do
  target_dir '/opt/tomcat'
  creates '/opt/tomcat/RUNNING.txt'
  tar_flags [ '-P', '--strip-components 1' ]
end

#change permission of /opt/tomcat
fileutils '/opt/tomcat' do
#  action :change
  group 'tomcat'
end

#Give the tomcat group read access to the conf directory and all of its contents
fileutils '/opt/tomcat/conf' do
#  directory_mode ['g+r']
#  file_mode ['g+r']
  file_mode 0640
end

#change only conf dir permission
fileutils '/opt/tomcat/conf' do
#  recursive false
  directory_mode 0750
end

#change permission of /webapps/ /work/ /temp/ /logs/
%w[ webapps work temp logs ].each do |path|
  directory "/opt/tomcat/#{path}" do
    owner 'tomcat'
  end
end

#add tomcat.service file
template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

#Reload systemd daemon
execute 'systemctl-daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

#Start tomcat service
service 'tomcat' do
  action :start
end

#Insert line in /opt/tomcat/conf/tomcat-users.xml
template '/opt/tomcat/conf/tomcat-users.xml' do
  source 'tomcat-users.xml.erb'
  notifies :restart,'service[tomcat]', :immediately
end

#comment out the IP address restriction to allow connections from anywhere, manager
template '/opt/tomcat/webapps/manager/META-INF/context.xml' do
  source 'context.xml.erb'
  notifies :restart,'service[tomcat]', :immediately
end

#comment out the IP address restriction to allow connections from anywhere, host-manager
template '/opt/tomcat/webapps/host-manager/META-INF/context.xml' do
  source 'context.xml.erb'
  notifies :restart,'service[tomcat]', :immediately
end

#Get port number for attribute
template '/opt/tomcat/conf/server.xml' do
  source 'server.xml.erb'
  notifies :restart,'service[tomcat]', :immediately
end
#add host-manager.xml to /opt/tomcat/conf
#template '/opt/tomcat/conf/host-manager.xml' do
#  source 'host-manager.xml.erb'
#end

#restart tomcat service
service 'tomcat' do
 action :start
end
