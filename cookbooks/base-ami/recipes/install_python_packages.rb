link 'set_python' do
  action :create
  link_type :symbolic
  target_file '/usr/bin/python'
  to '/usr/bin/python3'
end

python 'install_pip3' do
  action :nothing
  flags "get-pip.py"
end

[
  'pip',
  'setuptools',
  'wheel',
].each do | package_name |
  python 'python3' do
    action :nothing
    flags "-m install pip #{package_name}"
  end
end