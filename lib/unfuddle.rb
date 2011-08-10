require 'lib/unfuddle/changeset'
require 'lib/unfuddle/commit'
require 'lib/unfuddle/request'
require 'lib/unfuddle/account'
require 'lib/unfuddle/client'

module Unfuddle
  @@client = nil
  
  def self.setup(options={})
    @@client = Unfuddle::Client.new(
      options[:subdomain],
      options[:user],
      options[:password]
    )
  end
  
  def self.client
    @@client
  end
end