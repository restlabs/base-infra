file '/tmp/hello.txt' do
  owner 'scleft'
  group 'scleft'
  mode '0755'
  content "hello world\n"
  action :create
end
