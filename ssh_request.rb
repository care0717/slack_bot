require 'net/ssh'

def request_to_server(server_name, command, login_user)
  ssh_responce = []
  Net::SSH.start(server_name, login_user[:name], :password => login_user[:pass]) do |ssh|
    ssh_responce = ssh.exec! command
  end
  return  ssh_responce
end
