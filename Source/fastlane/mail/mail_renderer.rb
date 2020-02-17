require_relative 'art'
require 'erb'

# http://blog.revathskumar.com/2014/10/ruby-rendering-erb-template.html
class MailRenderer
  def initialize(version, base_url, issues)
    @groups = issues.group_by { |i| i.fields['issuetype']['name'] }
    @template = File.read('mail/mail_template.html.erb')
    @art = Art.load.sample
    @base_url = base_url
    @version = version
  end

  def render
    ERB.new(@template).result(binding)
  end
end
