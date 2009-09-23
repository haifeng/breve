class UserObserver < ActiveRecord::Observer
  def after_save(user)
    Mailer.deliver_reset_confirmation(user) unless user.reset_key.nil?
  end
end