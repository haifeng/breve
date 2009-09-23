class Mailer < ActionMailer::Base
  def reset_confirmation(user)
    content_type 'text/plain'
    sent_on      Time.now
    recipients   user.email
    from         'no-reply@breve.com'
    subject      'Password reset confirmation from breve.com'
    body         :user => user
  end
end
