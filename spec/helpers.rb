module Helpers
  def login_headers(user)
    {
      'X-User-Email' => user.email,
      'X-User-Token' => user.auth_token
    }
  end
end
