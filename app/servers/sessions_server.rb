class SessionsServer < CarrotRpc::RpcServer
  queue_name "sessions_queue"

  # In a production application I would use email and send off an activation email at this point
  # but for simplicity's sake I am just using a simple username field
  def create(params)
    user = User.find_by(username: params['username'])
    if user && user.authenticate(params['password'])
      { token: user.to_jwt }
    else
      { errors: ['Invalid username or password.'] }
    end
  end
end
