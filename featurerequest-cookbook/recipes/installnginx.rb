package 'nginx' do
	action :install
end

service 'nginx' do
	supports :restart => true, :reload => true
	action [:enable, :start]
end