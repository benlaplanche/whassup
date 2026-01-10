# CLAUDE.md - AI Assistant Guide for Whassup

## Project Overview

Whassup is a minimal Sinatra-based SMS webhook service that integrates with the Twilio API. It handles incoming SMS messages and delivery status callbacks, responding with TwiML (Twilio Markup Language) formatted responses.

## Codebase Structure

```
whassup/
├── server.rb       # Main application - all routes and logic
├── Gemfile         # Ruby dependency declarations
├── Gemfile.lock    # Locked dependency versions
└── CLAUDE.md       # This file
```

This is intentionally a flat, minimal structure with no subdirectories.

## Technology Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Ruby | >= 3.0 | Programming language |
| Sinatra | ~> 4.0 | Web framework |
| twilio-ruby | ~> 7.0 | Twilio SDK for TwiML generation |
| Puma | latest | HTTP server |
| Rackup | latest | Rack application launcher (required for Sinatra 4.x) |

## Development Setup

```bash
# Install dependencies
bundle install

# Start the server
bundle exec rackup

# Or with Puma directly
bundle exec puma
```

The server runs on the default Rack port (9292) unless configured otherwise.

## API Endpoints

### POST /incoming_message
Webhook endpoint for receiving incoming SMS from Twilio.
- **Input**: Twilio webhook POST parameters (From, To, Body, etc.)
- **Output**: TwiML XML response with acknowledgment message
- **Response**: Returns a `<Message>` TwiML response

### POST /status_callback
Webhook endpoint for Twilio delivery status updates.
- **Input**: MessageSid, MessageStatus parameters
- **Output**: None (204 No Content)
- **Behavior**: Logs status to stdout

### GET /
Health check endpoint.
- **Output**: Plain text response

## Code Conventions

### Style Guidelines
- Use Sinatra DSL directly (no separate controllers/models)
- Keep handlers simple and focused
- Use `Twilio::TwiML::MessagingResponse` for building TwiML responses
- Return 204 status for webhook acknowledgments that don't need response bodies

### Patterns Used
- **Request-Response**: Simple HTTP handlers
- **TwiML Builder**: Use Twilio SDK's block syntax for TwiML generation
- **Stateless Design**: No database or persistent storage

### Example TwiML Pattern
```ruby
post '/endpoint' do
  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message(body: 'Response text')
  end
  twiml.to_s
end
```

## Testing

**Note**: No test framework is currently configured. If adding tests:
- Use RSpec or Minitest
- Use `rack-test` for endpoint testing
- Mock Twilio API calls

## Key Files Reference

- `server.rb:4-10` - Incoming message handler with TwiML response
- `server.rb:12-19` - Status callback handler
- `server.rb:21-23` - Health check endpoint

## Important Notes for AI Assistants

### Do
- Keep the codebase minimal and flat
- Use Sinatra DSL patterns consistent with existing code
- Return appropriate HTTP status codes (200 for TwiML, 204 for callbacks)
- Use the Twilio Ruby SDK for TwiML generation

### Don't
- Add unnecessary abstractions or class hierarchies
- Create subdirectories unless absolutely necessary
- Add dependencies without clear justification
- Modify the response format expected by Twilio webhooks

### Security Considerations
- This app does not currently validate Twilio webhook signatures
- No authentication is implemented on endpoints
- Production deployments should add Twilio request validation

### Deployment Notes
- Stateless and horizontally scalable
- Can be deployed to any Ruby-compatible platform (Heroku, AWS, etc.)
- Puma provides multi-worker capability for concurrency
