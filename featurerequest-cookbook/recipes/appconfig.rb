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

