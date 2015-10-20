require "test_helper"

class HTML::Pipeline::LinkifyGitHubTest < Minitest::Test
  LinkifyGitHubFilter = HTML::Pipeline::LinkifyGitHubFilter

  def filter(html)
    LinkifyGitHubFilter.call(html)
  end

  def test_that_it_has_a_version_number
    assert HTML::Pipeline::LinkifyGitHub::VERSION
  end

  def pull_request_url
    "https://github.com/rails/rails/pull/21862"
  end

  def issue_url
    "https://github.com/rails/rails/issues/21843"
  end

  def commit_url
    "https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864"
  end

  def test_linkify_github_pull_request_html_link
    body = %Q(<a href="#{pull_request_url}">#{pull_request_url}</a>)
    doc  = Nokogiri::HTML::DocumentFragment.parse(body)

    res = filter(doc)
    assert_equal_html %Q(<a href="#{pull_request_url}">rails/rails#21862</a>),
                      res.to_html
  end

  def test_linkify_github_issue_html_link
    body = %Q(<a href="#{issue_url}">#{issue_url}</a>)
    doc  = Nokogiri::HTML::DocumentFragment.parse(body)

    res = filter(doc)
    assert_equal_html %Q(<a href="#{issue_url}">rails/rails#21843</a>),
                      res.to_html
  end

  def test_linkify_github_commit_html_link
    body = %Q(<a href="#{commit_url}">#{commit_url}</a>)
    doc  = Nokogiri::HTML::DocumentFragment.parse(body)

    res = filter(doc)
    assert_equal_html %Q(<a href="#{commit_url}">rails/rails@<code>67597e</code></a>),
                      res.to_html
  end
end
