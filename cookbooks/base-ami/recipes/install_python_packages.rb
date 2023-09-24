execute 'set_python' do
  command 'ln -s /usr/bin/python3 /usr/bin/python'
end

python 'python3' do
  code "get-pip.py"
end

[
  'pip',
  'setuptools',
  'wheel',
].each do | package_name |
  python 'python3' do
    code "-m install pip #{package_name}"
  end
end