template "/etc/samba/smb.conf" do
  action :create
  variables(user: ENV["SMB_USER"])
end

# Create a user and a samba user
group ENV["SMB_USER"] do
  gid ENV["SMB_USER_GID"].to_i
end

user ENV["SMB_USER"] do
  uid ENV["SMB_USER_UID"].to_i
  gid ENV["SMB_USER_GID"].to_i
  password ENV["SMB_PASSWORD"]
end

execute "Add a samba user" do
  command <<-COMMAND.gsub(/^ */, "")
    cat <<PASSWORD | smbpasswd -a -s #{ENV["SMB_USER"]}
    #{ENV["SMB_PASSWORD"]}
    #{ENV["SMB_PASSWORD"]}
    PASSWORD
  COMMAND
end
