#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
apt_update 'daily' do
   frequency 8
   action :periodic
end
