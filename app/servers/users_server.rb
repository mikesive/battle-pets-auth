class UsersServer < CarrotRpc::RpcServer
  queue_name "users_queue"

  # In a production application I would use email and send off an activation email at this point
  # but for simplicity's sake I am just using a simple username field
  def create(params)
    user = User.new(params)
    if user.save
      { token: user.to_jwt }
    else
      { errors: user.errors.full_messages }
    end
  end

  # Used to validate a user token
  def show(params)
    user = User.from_token(params[:token])
    user || { errors: ['Unauthorized'] }
  end

  # Ideally we would not update the password here
  # but rather have a seperate controller for that
  # and revoke the JWT token when that happens to get them
  # to login again, or send an email notifying the user of a
  # password change
  def update(params)
    user = User.from_token(params['token'])
    if user
      user.update(params.slice('username', 'password'))
      if user.errors.any?
        return { errors: user.errors.full_messages }
      else
        return { success: 'User updated.' }
      end
    else
      { errors: ['Unauthorized'] }
    end
  end
end
