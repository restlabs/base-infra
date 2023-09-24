python 'python3' do
  code "get-pip.py"
end

[
  'pip',
  'setuptools',
  'wheel',
].each do | package_name |
  python 'python3' do
    command "-m install pip #{package_name}"
  end
end