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

directory '/home/www' do
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