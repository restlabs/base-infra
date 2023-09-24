execute 'set_python' do
  command 'ln -s /usr/bin/python3 /usr/bin/python'
end

python 'install_pip3' do
  flags "get-pip.py"
end

[
  'pip',
  'setuptools',
  'wheel',
].each do | package_name |
  python 'python3' do
    flags "-m install pip #{package_name}"
  end
end