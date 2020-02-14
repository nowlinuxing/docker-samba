param = JSON.parse(ENV["SMB_PARAM"])
user = param["user"]

template "/etc/samba/smb.conf" do
  variables(user: user["name"])
end

# Create a user and a samba user
group user["name"] do
  gid user["gid"]
end

user user["name"] do
  uid user["uid"]
  gid user["gid"]
  password user["password"]
end

execute "Add a samba user" do
  command <<-COMMAND.gsub(/^ */, "")
    cat <<PASSWORD | smbpasswd -a -s #{user["name"]}
    #{user["password"]}
    #{user["password"]}
    PASSWORD
  COMMAND
end
