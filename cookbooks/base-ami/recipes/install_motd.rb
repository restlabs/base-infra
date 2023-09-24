file '/etc/motd' do
  content "This server is managed by Chef!"
  action :create
end
