APP_USER = node['app_name_prefix']

user "#{APP_USER}-user-00" do
  comment 'Base user'
  shell '/bin/bash'
  uid '1111'
end

user 'leet-user' do
  comment 'A 1337 h4xZ0r'
  shell '/bin/bash'
  uid '1337'
end
