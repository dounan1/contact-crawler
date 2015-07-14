class FormFinder
  class << self

    def find_forms(page)
      # has a form with email field and a message body

      return if page.doc.nil?

      contact_form_found = false;

      #search for contact form
      forms = page.doc.search('form')

      if forms.any?
        forms.each do |form|
          if contact_form_search(form)
            contact_form_found = true
            break
          end
        end
      end

      contact_form_found ? page.url.to_s : nil
    end

    def contact_form_search(form)
      content = form.content
      
      # p form.content
      email_field_found = !content.match(/email/i).nil?
      subject_field_found = !content.match(/subject/i).nil?
      comment_field_found = !content.match(/comment/i).nil?
      message_field_found = !content.match(/message/i).nil?

      # p 'email form found: ' + email_field_found.to_s
      # p 'subject form found: ' + subject_field_found.to_s
      # p 'comment form found: ' + comment_field_found.to_s
      # p 'message form found: ' + message_field_found.to_s

      email_field_found && (subject_field_found || comment_field_found || message_field_found)
    end
  end
end