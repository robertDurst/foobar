module AgendaReport
  class Reporter
    def initialize
      @emailer = AgendaReport::Emailer.new
      @pdf_generator = AgendaReport::PdfGenerator.new
    end

    def generate_and_send_report(daily_agenda)
      # Generate PDF report
      pdf_filename = "daily_agenda_report.pdf"
      
      @pdf_generator.generate_with_sections(
        sections: [
          {title: "Daily Agenda", content: daily_agenda},
        ],
        filename: pdf_filename,
        document_title: "Daily Agenda Report: #{Time.now.strftime('%Y-%m-%d')}"
      )

      # Send email with PDF attachment
      email_response = @emailer.send_email(
        to: ENV['GMAIL_LOCATION'],
        subject: "Daily Agenda Report",
        body: "Please find attached the daily agenda report.",
        pdf_path: pdf_filename
      )

      email_response
    end
  end
end