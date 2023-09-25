execute 'instal_epel' do
  command 'amazon-linux-extras install epel'
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

  yum_package package_name
end
