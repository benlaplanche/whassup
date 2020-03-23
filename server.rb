require 'twilio-ruby'
require 'sinatra'

post '/incoming_message' do
  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message(body: 'Ahoy! Thanks so much for your message.')
  end

  twiml.to_s
end

post '/status_callback' do
    message_sid = params['MessageSid']
    message_status = params['MessageStatus']
  
    print "SID: #{message_sid}, Status: #{message_status}\n"
  
    response.status = 204
end

get '/' do
    "blah blah blah"
end