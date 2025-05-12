require 'prawn'

module AgendaReport
  class PdfGenerator
    def initialize(options = {})
      @options = {
        page_size: 'A4',
        margin: 50
      }.merge(options)
    end

    def generate(content:, filename:, title: nil, font_size: 12)
      Prawn::Document.generate(filename, page_size: @options[:page_size], margin: @options[:margin]) do |pdf|
        # Add title if provided
        if title
          pdf.font("Helvetica", style: :bold) do
            pdf.text title, size: font_size + 6, align: :center
          end
          pdf.move_down 20
        end
        
        # Add content
        pdf.text content, size: font_size
        
        # Add page numbers
        pdf.number_pages "Page <page> of <total>", 
                        { at: [pdf.bounds.right - 150, 0], 
                          width: 150, 
                          align: :right, 
                          size: 10 }
      end
      
      filename
    end

    def generate_with_sections(sections:, filename:, document_title: nil)
      Prawn::Document.generate(filename, page_size: @options[:page_size], margin: @options[:margin]) do |pdf|
        # Add document title if provided
        if document_title
          pdf.font("Helvetica", style: :bold) do
            pdf.text document_title, size: 18, align: :center
          end
          pdf.move_down 20
        end
        
        # Add each section
        sections.each do |section|
          if section[:title]
            pdf.font("Helvetica", style: :bold) do
              pdf.text section[:title], size: 14
            end
            pdf.move_down 10
          end
          pdf.text section[:content], size: 12
          pdf.move_down 20
        end
        
        # Add page numbers
        pdf.number_pages "Page <page> of <total>", 
                        { at: [pdf.bounds.right - 150, 0], 
                          width: 150, 
                          align: :right, 
                          size: 10 }
      end
      
      filename
    end
  end
end
