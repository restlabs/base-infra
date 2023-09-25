# Chef InSpec test for recipe base-ami::default

# The Chef InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

control 'create_base_users' do
  title 'Creates base users'

  describe user('base-app-user-00') do
    it { should exist }
    its('home') { should eq '/home/base-app-user-00'}
    its('shell') { should eq '/bin/bash' }
    its('uid') { should eq '1111' }
  end

  describe user('leet-user') do
    it { should exist }
    its('home') { should eq '/home/leet-user'}
    its('shell') { should eq '/bin/bash' }
    its('uid') {should eq '1337'}
  end
end

control 'create_file' do
  title 'Create file'

  describe file('/tmp/hello.txt') do
    its('type') { should eq :file }
    its('owner') { should eq 'leet-user'}

    [
      'hello world'
    ].each do | line |
      its('content') { should match Regexp.new('^' + Regexp.escape( line ) + '$' ) }
    end
  end
end

control 'install_base_packages' do
  title 'Install base packages'

  [
    'epel-release',
    'git',
    'htop',
    'jq',
    'lynx',
    'net-tools',
    'screenfetch',
    'tmux',
    'unzip',
    'vim',
    'watch',
  ].each do | package_name |

    describe package(package_name) do
      it { should be_installed }
    end
  end
end

control 'install_apache' do
  title 'Install apache'

  case node[:platform]
  when 'amazon', 'centos', 'redhat'
    describe package('httpd') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  when 'debian', 'ubuntu'
    describe package('apache2') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end

  describe file('/var/www/html/index.html') do

    [
      'This is configured by Chef.',
      'DO NOT EDIT THIS MANUALLY!\n',
    ].each do | line |
      its('content') { should match Regexp.new('^' + Regexp.escape( line ) + '$' ) }
    end
  end
end

control 'install_motd' do
  title 'Install motd'

  describe file('/etc/motd') do
    [
      'This server is managed by Chef!',
    ].each do | line |
      its('content') { should match Regexp.new('^' + Regexp.escape( line ) + '$' ) }
    end
  end
end

control 'install_python_packages' do
  title 'Install python packages'

  describe command('/usr/bin/python --version') do
    its('stdout') { should eq 'Python 3.11.0' + "\n" }
  end
end