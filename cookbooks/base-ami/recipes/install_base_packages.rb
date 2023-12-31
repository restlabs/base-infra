execute 'yum update -y'
execute 'whoami'
execute 'yum groupinstall -y "Development Tools"'

execute 'install_epel' do
  command 'amazon-linux-extras install epel'
end

# [
#   'git',
#   'htop',
#   'jq',
#   'lynx',
#   'net-tools',
#   'tmux',
#   'unzip',
#   'vim',
#   'watch',
# ].each do | package_name |
#   execute 'install_packages' do
#     command "yum install -y #{package_name}"
#   end
# end

[
  'epel-release',
  'git',
  'htop',
  'jq',
  'lynx',
  'net-tools',
  'tmux',
  'unzip',
  'vim',
  'watch',
].each do | package_name |
  package package_name
end
