require 'tilt/haml'
require 'json'

module Indigo

  class Controller

    def self.validate_helper(params)
      if params['g-recaptcha-response'].to_s.empty?
        #raise "Please check the \"I'm not a robot\" checkbox"
      end
      if ['email','phone'].all?{|x| params[x].to_s.empty? }
        raise "At least one of email & contact number is required"
      end
    end

    def self.book_therapy(params)
      validate_helper(params)

      email_people(params, :therapy)
    end

    def self.book_workshop(params)
      validate_helper(params)

      email_people(params, :workshop)
    end

    def self.contact(params)
      validate_helper(params)

      email_people(params, :contact)
    end

    def self.email_people(params, src)
      if src == :therapy
        subject = "Therapy appointment request"

        #email_client(params[:email], subject, "placeholder")

      elsif src == :workshop
        subject = "Workshop appointment request"

        #email_client(params[:email], subject, "placeholder")

      elsif src == :contact
        subject = "We have received your message"

        #email_client(params[:email], subject, params[:msg])
      end

      admin_body = admin_email_body(params, src)

      email_admin(params[:name], params[:email], subject, admin_body)
    end

    def self.stringify_form(data, fields)
      languages = {en: 'English', hi: 'Hindi', gu: 'Gujarati', ma: 'Malyalam'}
      modes = {f2f: 'Face to Face', tel: 'Telephonic', email: 'Email', vid: 'Video (Skype/Hangouts)', chat: 'Chat (Skype/Hangouts)'}

      return fields.map do |f|
        val = data[f[:key]]
        if val
          if f[:key] == :lang
            val.map!{|v| languages[v.to_sym] }
          elsif f[:key] == :mode
            val = modes[val.to_sym]
          end
          val = val.join(', ') if val.is_a? Array
          "#{f[:label]}: #{val}"
        end
      end.compact.join("\n")
    end

    def self.admin_email_body(params, src)
      if src == :therapy
        fields = [
          { label: "Name", key: :name },
          { label: "Email", key: :email },
          { label: "Phone no.", key: :phone },
          { label: "Appointment date/time", key: :schedule },
          { label: "Languages", key: :lang },
          { label: "Mode of therapy", key: :mode },
        ]
        form_text = stringify_form(params, fields)

        body = "You have a new therapy appointment request:\n\n#{form_text}\n"

      elsif src == :workshop
        fields = [
          { label: "Name", key: :name },
          { label: "Email", key: :email },
          { label: "Phone no.", key: :phone },
          { label: "Requirement description", key: :desc },
          { label: "Location", key: :city },
          { label: "Workshop date/time", key: :schedule },
          { label: "Languages", key: :lang },
        ]
        form_text = stringify_form(params, fields)

        body = "You have a new workshop request:\n\n#{form_text}\n"

      elsif src == :contact
        fields = [
          { label: "Name", key: :name },
          { label: "Email", key: :email },
          { label: "Phone no.", key: :phone },
          { label: "Message", key: :msg },
        ]
        form_text = stringify_form(params, fields)

        body = "You have a contact message:\n\n#{form_text}\n"
      end

      return body
    end

    def self.email_admin(client_name, client_email, subject, body)
      opts = {
        from: "info@innerdialogue.in (#{client_name})",
        to: ENV['ADMIN_EMAIL'],
        subject: subject,
        body: body,
      }
      opts[:reply_to] = client_email if not client_email.to_s.empty?
      Pony.mail(opts)
    end

    def self.email_client(recepient_email, subject, body)
      opts = {
        from: "info@innerdialogue.in (Inner Dialogue)",
        to: recepient_email,
        subject: subject,
        body: body,
      }
      Pony.mail(opts) if not recepient_email.to_s.empty?
    end

    def self.ajax
      begin
        yield
        {status: "success"}
      rescue RuntimeError => e
        puts e.backtrace
        {status: "error", message: e.message}
      rescue => e
        puts e, e.message
        puts e.backtrace
        {status: "fatal", message: e.message}
      end.to_json
    end

  end

  class Application < Sinatra::Application

    def self.load_rb_dir dir
      Dir["#{dir}/*.rb"].sort.each { |rb| require File.join(File.dirname(__FILE__), rb) }
    end

    configure do
      Pony.options = {
        to: ENV['ADMIN_EMAIL'],
        via: :smtp,
        via_options: {
          openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
          address: ENV['SMTP_HOST'],
          port: 25,
          user_name: ENV['SMTP_USER'],
          password: ENV['SMTP_PASS'],
          authentication: :plain,
        }
      }
    end

    get '/?' do
      haml :index
    end

    post '/ajax/:method/?' do
      Controller.ajax do
        Controller.send(params[:method].gsub('-','_'), params)
      end
    end

  end

end
