file '/etc/init/featurerequest' do
	action :delete
	only_if { File.exist? '/etc/init/featurerequest'}
end