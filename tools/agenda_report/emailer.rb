require 'dotenv/load' 
require 'mail'

module AgendaReport
  class Emailer
    def initialize
      Mail.defaults do
        delivery_method :smtp, address: 'smtp.gmail.com',
                               port: 587,
                               user_name: ENV['GMAIL_USER'],
                               password: ENV['GMAIL_PASS'],
                               authentication: 'plain',
                               enable_starttls_auto: true
      end
    end
    
    def send_email(to:, subject:, body:, pdf_path: nil)
      begin
        mail = Mail.new do
          from    ENV['GMAIL_USER']
          to      to
          subject subject
          body    body
          
          if pdf_path && File.exist?(pdf_path)
            add_file pdf_path
          end
        end
        
        mail.deliver!
        
        {
          success: true,
          message: "Email sent successfully",
          message_id: mail.message_id
        }
      rescue => e
        {
          success: false,
          error: "Error sending email: #{e.message}"
        }
      end
    end
  end
end
