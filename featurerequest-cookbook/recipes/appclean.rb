file '/etc/init/featurerequest.conf' do
	action :delete
	only_if { File.exist? '/etc/init/featurerequest.conf'}
end