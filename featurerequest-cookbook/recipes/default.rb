include_recipe 'featurerequest-cookbook::aptupdater'
include_recipe 'featurerequest-cookbook::installnginx'

file '/etc/nginx/sites-enabled/default' do
	action :delete
	only_if { File.exist? '/etc/nginx/sites-enabled/default'}
end

template "/etc/nginx/sites-available/featurerequest" do
	source 'featurerequest.erb'
end

link '/etc/nginx/sites-enabled/featurerequest' do
	to '/etc/nginx/sites-available/featurerequest'
end
