directory "/tmp/featurerequest" do
	recursive true
	action :delete
end
git '/tmp/featurerequest' do
	repository 'https://github.com/chandanadatta9/FeatureRequest.git'
	revision 'master'
	action :sync
end
bash "get_code" do
	user "root"
	cwd '/home/www'
	code <<-EOL
		source env/bin/activate
		cp -r /tmp/featurerequest/* .
		cd featurerequest/
		pip install -r requirements.txt
		pip install gunicorn
		export DATABASE_HOST="#{node['DATABASE_HOST']}"
		export DATABASE_USER="#{node['DATABASE_USER']}"
		export DATABASE_PASSWORD="#{node['DATABASE_PASSWORD']}"
		export DATABASE_PRODUCTION_NAME="#{node['DATABASE_NAME']}"
		gunicorn run_production:app --reload -b #{node["opsworks"]["instance"]["private_ip"]}:8000
	EOL
end
