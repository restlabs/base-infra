#
# Cookbook:: base-ami
# Recipe:: default
#
# Copyright:: 2023, scleft, All Rights Reserved.

include_recipe '::create_base_users'
include_recipe '::create_file'
include_recipe '::install_base_packages'
include_recipe '::install_apache'
include_recipe '::install_motd'
include_recipe '::install_python_packages'
