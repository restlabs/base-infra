execute 'install_epel' do
  command 'amazon-linux-extras install epel'
end

execute 'set_locale' do
  command 'export LC_ALL=en_US.UTF-8'
end

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

  package package_name
end
