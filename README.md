# SMSEasy (sms-easy)

SMSEasy allows you to send SMS messages from your Ruby application for free using email-to-text services provided by many carriers.

This is largely based on Brendan Lim's sms-fu for older apps. (https://github.com/brendanlim/sms-fu) If you're replacing sms-fu, SMSEasy is very similar, but not identical, and does not support legacy versions of activerecord.

Rails 4 integration is supported, though not required. Additionally, SMSEasy works perfectly well with background job processing gems such as Sidekiq and delayed_job.


## Supported Carriers (US & International):

Alltel, Ameritech, AT&T, Bell Atlantic, BellSouth Mobility, Beeline(UA), BlueSkyFrog,
Boost Mobile, BPL Mobile, Cellular South, Claro (Brazil, Nicaragua), Comcast, Du,
E-Plus, Etisalat, Fido, kajeet, Mobinil, Mobitel, Movistar, Metro PCS, O2, Orange,
Powertel, PSC Wireless, Qwest, Rogers, Southern Link, Sprint, Suncom,
T-Mobile (US/UK/Germany), Telefonica, Tracfone, Virgin Mobile, Verizon Wireless,
Vodafone (UK, Egypt, Italy, Japan, Spain), and many more ...

Some International carriers require that their users subscribe to an Email to SMS
feature before they are able to receive SMS messages this way.  If one your users
mentions that they are not receiving their messages, chances are it is due to this
limitation.  Some of these carriers are include, Mobitel, Etisalat, T-Mobile (Netherlands).

## Requirements

* SMSEasy requires the use of a recent version of 'action\_mailer'. Unlike the older sms-fu gem, **_only_ action\_mailer 4/5 is supported**. If you have an older app, please try one of the older variants that supports action\_mailer 3 and/or pony email agents.


## Setup Instructions

Install the sms-easy gem:

    gem install sms-easy




## Numbers and Carriers

* You'll need 10-digit phone numbers, stripped of any non-numeric characters.
* As SMSEasy relies on free carrier-specific email-to-SMS gateways, you'll also need to know the carrier of the receiving phone number.
* Here are some of the default carrier values:

    Alltel Wireless   =>  "alltel"
    AT&T/Cingular     =>  "at&t"
    Boost Mobile      =>  "boost"
    Sprint Wireless   =>  "sprint"
    T-Mobile US       =>  "t-mobile"
    T-Mobile UK       =>  "t-mobile-uk"
    Virgin Mobile     =>  "virgin"
    Verizon Wireless  =>  "verizon"
    Vodafone Tokyo    =>  "vodafone-jp-tokyo"

* Check sms-easy.yml for a complete list of supported carriers, including international carriers.

## Usage

###Basic Rails Configuration

    # Override the default "from" address with config/initializers/sms-easy.rb
    SMSEasy::Client.config['from_address'] = "noreply@example.com"

    # Or, you can completely copy sms-easy.yml to your app (http://github.com/preston/sms-easy/blob/master/templates/sms-easy.yml), change it to your liking, and override the default configuration with:

    SMSEasy::Client.configure(YAML.load(...))

    # Your apps existing ActionMailer configuration will be used. :)

    # Create the client
    easy = SMSEasy::Client.new

    # Deliver a simple message.
    easy.deliver("5551234567", "verizon", "Hey!")  

### Basic Ruby (non-Rails) Use Case (non-Rails)

    # SMSEasy will use actionmailer's default configuration, which can be overriden if needed:
    ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.example.com',
      # :port           => '587',
      :domain         => 'example.com',
      :enable_starttls_auto => false
    }

    # Configure SMSEasy's "from" address:
    SMSEasy::Client.config['from_address'] = "noreply@example.com"

    # Optionally override the carries list using your own data file.
    # SMSEasy::Client.configure(YAML.load(...))

    # Create the client
    easy = SMSEasy::Client.new

    # Deliver a simple message.
    easy.deliver("5551234567", "verizon", "Hey!")

    # To set a custom from e-mail per SMS message:
    easy.deliver("5551234567", "verizon", "Sup.", :from => "bob@test.com")

    # You can set the maximum length of the SMS message, which is not set by default.  Most phones can only accept 128 characters.  To do this just specify the limit option.

    easy.deliver("5551234567", "verizon", "Boo-yaa!", :limit => 128)

	# You can retrieve just the formatted address to use in your own mailer.
    SMSEasy::Client.sms_address("5558675309","at&t") # => "5558675309@txt.att.net"

## View Helpers (Rails)

Include view helpers in application_helper.rb:

	module ApplicationHelper
      include SMSEasyHelper
    end

Retrieve a collection of all carriers

    <%= carrier_collection %>

Display a select box with mobile carriers

    <%= carrier_select %>

Display a custom select box with mobile carriers

    <%= carrier_select('user[carrier_name]', "Please choose a carrier") %>

## Special Thanks

I want to thank the following individuals with their help with adding some patches to SMS Fu:

* Brent Collier (brentmc79)
* Peter Boling (pboling)
* Mike (mic)

Copyright (c) 2010 Brendan G. Lim, Intridea, Inc., released under the MIT license

Additional modifications, updates, refactorings etc. by Preston Lee 2013-2017.
