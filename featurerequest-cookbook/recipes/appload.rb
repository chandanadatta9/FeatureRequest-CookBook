directory "/tmp/featurerequest" do
	recursive true
	action :delete
end
git '/tmp/featurerequest' do
	repository 'https://github.com/chandanadatta9/FeatureRequest.git'
	revision 'master'
	action :sync
end
serverIP = search("aws_opsworks_instance","self:true").first
bash "get_code" do
	user "root"
	cwd '/home/www'
	timeout 300
	returns [0, 1]
	code <<-EOL
		source env/bin/activate
		cd featurerequest/
		cp -r /tmp/featurerequest/* .
		pip install -r requirements.txt
		pip install gunicorn
		export DATABASE_HOST="#{node['DATABASE_HOST']}"
		export DATABASE_USER="#{node['DATABASE_USER']}"
		export DATABASE_PASSWORD="#{node['DATABASE_PASSWORD']}"
		export DATABASE_PRODUCTION_NAME="#{node['DATABASE_NAME']}"
	EOL
end

service 'featurerequest' do
	provider Chef::Provider::Service::Upstart
	supports :status => true
	action [:start, :restart]
end