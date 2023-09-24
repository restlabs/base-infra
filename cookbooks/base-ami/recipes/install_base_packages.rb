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
].each do | package_name |
  apt_package package_name
end
