
# Cookbook Name:: ntop
#
# Provider:: config
#

include Ntop::Helper

action :add do
  begin

    yum_package "ntp" do
      action :upgrade
      flush_cache [:before]
    end
      
    template "/etc/ntp.conf" do
      source "ntp.conf.erb"
      owner "root"
      group "root"
      mode 0644
      cookbook "ntp"
      variables(:server_0 => node["ntp"]["server_0"], :server_1 => node["ntp"]["server_1"], :server_2 => node["ntp"]["server_2"], :server_3 => node["ntp"]["server_3"])
      notifies :restart, "service[ntp]"
    end
    
    service "ntp" do
      service_name "ntpd"
      ignore_failure true
      supports :status => true, :reload => true, :restart => true, :enable => true
      action [:start, :enable]
    end

    Chef::Log.info("Ntp cookbook has been processed")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin
    
    service "ntp" do
      service_name "ntpd"
      ignore_failure true
      supports :status => true, :enable => true
      action [:stop, :disable]
    end

    file "/etc/ntp.conf" do
      action :delete
    end

    Chef::Log.info("Ntp cookbook has been processed")
  rescue => e
    Chef::Log.error(e.message)
  end
end

