template "/etc/samba/smb.conf" do
  action :create
  variables(user: ENV["SMB_USER"])
end
