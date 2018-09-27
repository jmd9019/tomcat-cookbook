# # encoding: utf-8

# Inspec test for recipe tomcat::tomcat

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

#check java
describe package('default-jdk') do
  it { should be_installed }
end

#check tomcat user
describe user('tomcat') do
  it { should exist }
  its('home') { should eq '/opt/tomcat' }
  its('shell') { should eq '/bin/false' }
end

#check tomcat group
describe group('tomcat') do
  it { should exist }
end

#check tomcat unzip
describe file('/opt/tomcat/RUNNING.txt') do
 it { should exist }
end

#check /opt/tomcat group owner
describe directory('/opt/tomcat') do
  its('group') { should eq 'tomcat' }
end

#check /op/tomcat/conf dir permission
describe directory('/opt/tomcat/conf') do
  its('mode') { should cmp '0750' }
end

#check port 8080
#port 8080 listining
describe port(8080) do
  it { should be_listening }
end

#check host-manager page login access
describe command('curl -u jmd:jmd http://ec2-18-234-123-95.compute-1.amazonaws.com:8080/host-manager/html') do
  its('stdout') { should_not match '401 Unauthorized' }
end

#check manager page login access
describe command('curl -u jmd:jmd http://ec2-18-234-123-95.compute-1.amazonaws.com:8080/manager/html') do
  its('stdout') { should_not match '401 Unauthorized' }
end

#check server status page access
describe command('curl -u jmd:jmd http://ec2-18-234-123-95.compute-1.amazonaws.com:8080/manager/status') do
  its('stdout') { should_not match '401 Unauthorized' }
end
