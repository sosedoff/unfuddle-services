Unfuddle Services
=================

This is a simple sinatra-based application to process url callbacks from Unfuddle.

Its pretty much similar to github's services.

## Install

This app is still in early development so no downloads are available at this moment.

## Usage

Setup application to run under passenger phusion, unicorn or thin.

Then point add a URL callback in your unfuddle repository:

    http://your.url/push
    
Dont forget to add file REPO_ID.yml to config/hooks folder. That's how the system knows that this repo is being connected.

## Supported services

- Basecamp - http://basecamphq.com/
- Postbin - http://www.postbin.org/
- Campfire (incoming) - http://campfirenow.com/

### Basecamp

Basecamp hook works really simple. It posts a new message into a single thread on basecamp's project.

Add section 'basecamp' into your repo config file.

    basecamp:
      ssl: true
      subdomain: "your subdomain"
      api_token: "your API token"
      project: "ID of the project to post"
      post: "ID of the post to post"
      
### Campfire

Campfire hook allows service to post commit messages into one of the specified rooms.

Add section 'campfire' into your repo config file.

    campfire:
      subdomain: "your subdomain"
      api_token: "your API token"
      room: "your room ID"

### Postbin

Postbin gives you place to test data from http requests. You should have similar url:

    http://www.postbin.org/YOUR_TOKEN

Add section 'postbin':

    postbin:
      token: 'YOUR_TOKEN'

## Developing services

If you want to add another service, please follow this pattern:

    module Services
      class MyService < Services::Base
        def initialize(config={})
          @config = config
          @username = @config[:username] || ''
          @password = @config[:password] || ''
        end
        
        # Transform changeset into desired format
        def render(changeset)
          "Commit: #{changeset.commit} by #{changeset.author}"
        end
    
        # Perform actions with changeset
        def push(changeset)
          http_post("YOUR_SERVICE_URL", render(changeset))
        end
    
        # Returns true of false if provided config data is valid
        def valid?
          !@username.empty? && !@password.empty?
        end
      end
    end

New service file should be placed under lib/services with a proper name (ex.: MyService -> my_service).

Also, each service should be supplied with a test file (spec/service_my_service_spec.rb).

## License

Copyright &copy; 2011 Dan Sosedoff.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.