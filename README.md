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

## Supported hooks

- Basecamp
- Campfire (incoming)

### Basecamp

Basecamp hook works really simple. It posts a new message into a single thread on basecamp's project.

Add section 'basecamp' into your repo config file.

    basecamp:
      ssl: true
      subdomain: "your subdomain"
      api_token: "your API token"
      project: "ID of the project to post"
      post: "ID of the post to post"
      

## License

Copyright &copy; 2011 Dan Sosedoff.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.