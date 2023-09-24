file '/etc/motd' do
  content "this is server is managed by Chef!"
  action :create
end
