file '/tmp/hello.txt' do
  owner 'leet-user'
  group 'leet-user'
  mode '0755'
  content "hello world\n"
  action :create
end
