class SMSEasyNotifier < ActionMailer::Base
  def send_sms(recipient, message, sender_email)
    mail(:to => recipient, :from => sender_email, :subject => '') do |format|
      format.text { render :plain => message, :layout => false }
      format.html { render :plain => message, :layout => false }
    end
  end  
end
