PIP_INSTALLER_URL = 'https://bootstrap.pypa.io/get-pip.py'

link 'set_python' do
  action :create
  link_type :symbolic
  target_file '/usr/bin/python'
  to '/usr/bin/python3'
end

execute 'install_pip3' do
  command "curl #{PIP_INSTALLER_URL} > get-pip.py && sudo python get-pip.py && rm -f get-pip.py"
end

execute 'update_pip' do
  command 'python -m pip install --upgrade pip'
end

[
  'pip',
  'setuptools',
  'wheel',
].each do | package_name |
  execute 'install_python_packages' do
    command "python -m pip install #{package_name}"
  end
end