require "bundler/setup"
require "minitest/autorun"
require "html/pipeline/linkify_github"

module LinkifyGitHubTestExtensions
  def assert_equal_html(expected, actual)
    assert_equal Nokogiri::HTML::DocumentFragment.parse(expected).to_hash,
                 Nokogiri::HTML::DocumentFragment.parse(actual).to_hash
  end
end

class Minitest::Test
  include LinkifyGitHubTestExtensions
end

class String
  def strip_heredoc
    gsub(/^#{scan(/^[ \t]*(?=\S)/).min}/, "".freeze)
  end
end
