[
  'git',
  'htop',
  'jq',
  'lynx',
  'net-tools',
  'screenfetch',
  'tmux',
  'unzip',
  'vim',
  'watch',
].each do | package_name |
  apt_package package_name
end

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