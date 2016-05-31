require "./cr_slack_cleanup/*"
require "option_parser"

opt_domain = ""
opt_token = ""

OptionParser.parse! do |opts|
  # Set a banner, displayed at the top
  # of the help screen.
  opts.banner = "Removes files from your free Slack account to stop the storage off limits warning."

  opts.on( "-t API_TOKEN", "--token API_TOKEN", "Your account's private API TOKEN" ) do |token|
    opt_token = token
  end

  opts.on( "-d DOMAIN", "--domain DOMAIN", "Your organization's domain name as registered in your Slack account" ) do |domain|
    opt_domain = domain
  end

  # This displays the help screen, all programs are
  # assumed to have this option.
  opts.on( "-h", "--help", "Display this screen" ) do
    puts opts
    exit
  end
end

puts "Fetching all files to be deleted ... "
payload = CrSlackCleanup::Files.new(opt_token).fetch!
puts "#{( payload.try &.files.size ) || 0} files found."
puts "Deleting all files ... "
janitor = CrSlackCleanup::Janitor.new(opt_domain, opt_token, payload)
janitor.cleanup!
puts "Done!"
