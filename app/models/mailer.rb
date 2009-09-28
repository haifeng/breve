class Mailer < ActionMailer::Base
  def reset_confirmation(user)
    content_type 'text/plain'
    sent_on      Time.now
    recipients   user.email
    from         'noreply@breve.com'
    reply_to     'noreply@breve.com'
    subject      'Password reset confirmation from breve.com'
    body         :user => user
  end

  def account_confirmation(user)
    content_type 'text/plain'
    sent_on      Time.now
    recipients   user.email
    from         'noreply@breve.com'
    reply_to     'noreply@breve.com'
    subject      'Account confirmation from breve.com'
    body         :user => user
  end
end
