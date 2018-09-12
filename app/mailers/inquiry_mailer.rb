class InquiryMailer < ActionMailer::Base
  default from: ENV['GMAILADDRESS']   # 送信元アドレス
  default to: ENV['GMAILADDRESS']     # 送信先アドレス

  def received_email(inquiry)
    @inquiry = inquiry
    mail(:subject => 'お問合せ：' + @inquiry.name)
  end

end
