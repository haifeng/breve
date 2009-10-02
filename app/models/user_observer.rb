class UserObserver < ActiveRecord::Observer
  def after_save(user)
    Mailer.deliver_reset_confirmation(user.normalized) unless user.reset_key.nil?
  end
  
  def after_create(user)
    Mailer.deliver_account_confirmation(user.normalized) unless user.activation_key.nil?
  end
end