link 'set_python' do
  action :create
  link_type :symbolic
  target_file '/usr/bin/python'
  to '/usr/bin/python3'
end

execute 'install_pip3' do
  command 'python get-pip.py'
end

[
  'pip',
  'setuptools',
  'wheel',
].each do | package_name |
  execute 'install_python_packages' do
    command "python -m install pip #{package_name}"
  end
end