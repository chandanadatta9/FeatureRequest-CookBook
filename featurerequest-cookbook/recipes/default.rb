include_recipe 'featurerequest-cookbook::aptupdater'
include_recipe 'featurerequest-cookbook::installnginx'

file '/etc/nginx/sites-enabled/default' do
	action :delete
	only_if { File.exist? '/etc/nginx/sites-enabled/default'}
end
webinstance = search("aws_opsworks_instance","self:true").first
appinstance = search("aws_opsworks_instance","hostname:python-app#{webinstance["hostname"][/\d+/].to_i}").first
template "/etc/nginx/sites-available/featurerequest" do
	source 'featurerequest.erb'
	variables = (
		:app_privateip => appinstance["private_ip"]
		)
end

link '/etc/nginx/sites-enabled/featurerequest' do
	to '/etc/nginx/sites-available/featurerequest'
end
