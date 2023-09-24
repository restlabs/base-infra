execute 'check_platform' do
  command "echo #{node[:platform]}"
end

apt_package 'Install Apache' do
  case node[:platform]
  when 'amazon', 'centos', 'redhat'
    package_name 'httpd'
  when 'debian', 'ubuntu'
    package_name 'apache2'
   end
end

file '/var/www/html/index.html' do
  content "This is configured by Chef. DO NOT EDIT THIS MANUALLY!\n"
  action :create
end

service 'start_apache' do
  action :enable

  case node[:platform]
  when 'amazon', 'centos', 'redhat'
    service_name 'httpd'
  when 'debian', 'ubuntu'
    service_name 'apache2'
  end
end