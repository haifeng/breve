module SessionHelper
  def authorized?
    not session[:user].nil?
  end
  
  def current_user(field = :id)
    return '' if session[:user].nil?
    session[:user].send(field)
  end
end
