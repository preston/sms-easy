module SMSEasy

  class Client

    @@config = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '..', '..', 'templates', 'sms-easy.yml')))

    # Delivers the SMS message in the form of an e-mail
    #   sms-easy.deliver("1234567890","at&t","hello world")
    def deliver(number, carrier, message, options = {})
      raise SMSEasyException.new("Can't deliver blank message to #{SMSEasy::Client.format_number(number)}") if message.nil? || message.empty?

      limit   = options[:limit] || message.length
      from    = options[:from] || SMSEasy::Client.from_address
      message = message[0..limit-1]
      email   = SMSEasy::Client.sms_address(number,carrier)

      if @delivery == :pony
        Pony.mail({:to => email, :body => message, :from => from}.merge!(@pony_config))
      else
        ActionMailer::Base.mail(from: from, to: email, body: message).deliver_now!
        
      end
    end

    class << self
      def configure(opts = {})
        @@config.merge!(opts)
        # require 'pp'
        # pp @@@@config
      end

      def config
        @@config
      end

      # Returns back a list of all carriers
      #   SMSEasy.carriers
      def carriers
        @@config['carriers']
      end

      def from_address
        @@config['from_address']
      end

      def carrier_name(key)
        carrier(key)['name']
      end

      def carrier_email(key)
        carrier(key.downcase)['value']
      end

      def carrier(key)
        raise SMSEasyException.new("Carrier (#{key}) is not supported") unless SMSEasy::Client.carriers.has_key?(key.downcase)
        carriers[key]
      end

      # Returns back a properly formatted SMS e-mail address
      #   SMSEasy.sms_address("1234567890","at&t")
      def sms_address(number,carrier)
        raise SMSEasyException.new("Missing number or carrier") if number.nil? || carrier.nil?
          format_number(number) + carrier_email(carrier.downcase)
      end

      def format_number(number)
        stripped = number.gsub("-","").strip
        formatted = (stripped.length == 11 && stripped[0,1] == "1") ? stripped[1..stripped.length] : stripped
        raise SMSEasyException.new("Number (#{number}) is not formatted correctly") unless valid_number?(formatted)
        formatted
      end

      def valid_number?(number)
        number.length >= 10 && number[/^.\d+$/]
      end

    end

  end
end
