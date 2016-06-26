#!/bin/ruby
#
# The validates that all controllable quality metrics receive maximum score
#
# Metrics are at: https://guides.cocoapods.org/making/quality-indexes.html
#

require "rubygems"
require "json"
require "net/http"
require "uri"

uri = URI.parse("http://metrics.cocoapods.org/api/v1/pods/FDBarGuage")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
passing = true

if response.code == "200"
  stats = JSON.parse(response.body)

  # Popularity Metrics
  # This is NOT controllable, we do not test for this

  # Swift Package Manager
  if stats["cocoadocs"]["spm_support"]
    puts "Full points awarded for: Supports Swift Package Manager"
  else
    puts "FAILED to award full points for: Supports Swift Package Manager"
    passing = false
  end

  # Inline Documentation
  if stats["cocoadocs"]["doc_percent"].to_i > 90
    puts "Full points awarded for: Great Documentation"
  else
    puts "FAILED to award full points for: Great Documentation"
    passing = false
  end

  # README Scoring
  if stats["cocoadocs"]["readme_complexity"].to_i > 75
    puts "Full points awarded for: Great README"
  else
    puts "FAILED to award full points for: Great README"
    passing = false
  end

  # CHANGELOG
  if stats["cocoadocs"]["rendered_changelog_url"] != nil
    puts "Full points awarded for: Has a CHANGELOG"
  else
    puts "FAILED to award full points for: Has a CHANGELOG"
    passing = false
  end

  # Language Choices
  if stats["cocoadocs"]["dominant_language"] == "Swift"
    puts "Full points awarded for: Built in Swift"
  else
    puts "FAILED to award full points for: Built in Swift"
    passing = false
  end

  # Licensing Issues
  if stats["cocoadocs"]["license_short_name"] =~ /GPL/i || false
    puts "FAILED to award full points because: Uses GPL"
    passing = false
  elseif stats["cocoadocs"]["license_short_name"] == "WTFPL"
    puts "FAILED to award full points because: Uses WTFPL"
    passing = false
  else
    puts "Full points awarded for: Licensing Issues"
  end

  # Code Calls
  if stats["cocoadocs"]["total_test_expectations"].to_i > 10
    puts "Full points awarded for: Has Tests"
  else
    puts "FAILED to award full points for: Has Tests"
    passing = false
  end
  if stats["cocoadocs"]["total_test_expectations"].to_f / stats["cocoadocs"]["total_lines_of_code"].to_f > 0.45
    puts "Full points awarded for: Test Expectations / Line of Code"
  else
    puts "FAILED to award full points for: Test Expectations / Line of Code"
    passing = false
  end

  # Ownership
  # This is NOT controllable, we do not test for this

  # Maintainance
  #
  #  Modifier.new("Post-1.0.0", "Has a Semantic Version that is above 1.0.0", 5, { |...|
  #  Pod::Version.new("1.0.0") < Pod::Version.new(spec.version)
  # }),
  puts "THE VERSION SHOULD BE GREATER THAN OR EQUAL TO 1.0.0"
  puts "TODO: PLEASE HELP TO UPDATE THIS CODE"

  # Misc - GitHub specific
  if stats["github"]["open_issues"].to_i < 50
    puts "Full points awarded for: Lots of open issues"
  else
    puts "FAILED to award full points because of: Lots of open issues"
    passing = false
  end
else
  puts "ERROR!!!"
  exit 1
end

exit passing ? 0 : 1
