include_recipe 'featurerequest-cookbook::aptupdater'

[ "python", "python-pip", "git" ].each do |packagename|
	package packagename do 
		action :install
	end
end

execute 'virtualenvinstall' do
	command "sudo pip install virtualenv"
	action :run
end

directory '/home/www/featurerequest' do
	user 'root'
	recursive true
	action :create
end

bash "create_venv" do
	user 'root'
	cwd '/home/www'
	code <<-EOL
		virtualenv env
	EOL
end

appinstance = search("aws_opsworks_instance","self:true").first
template "/etc/init/featurerequest.conf" do
	source 'featurerequest.conf.erb'
	variables(
		:DATABASENAME => node['DATABASE_NAME'],
		:DATABASEUSER => node['DATABASE_USER'],
		:DATABASEPASSWORD => node['DATABASE_PASSWORD'],
		:DATABASEHOST => node['DATABASE_HOST'],
		:app_privateip => appinstance["private_ip"]
		)
end

file '/etc/init.d/featurerequest' do
	action :delete
	only_if { File.exist? '/etc/init.d/featurerequest'}
end

link '/lib/init/upstart-job' do
	to '/etc/init.d/featurerequest'
	link_type :symbolic
end