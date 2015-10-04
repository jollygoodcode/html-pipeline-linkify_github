require "test_helper"

class HTML::Pipeline::LinkifyGitHubTest < Minitest::Test
  LinkifyGitHubFilter = HTML::Pipeline::LinkifyGitHubFilter

  def filter(text)
    LinkifyGitHubFilter.to_html(text)
  end

  def test_that_it_has_a_version_number
    assert HTML::Pipeline::LinkifyGitHub::VERSION
  end

  def test_that_normal_url_will_not_linkify
    text = "https://www.deppbot.com"

    assert_equal text, filter(text)
  end

  # == Pull Request

  def test_that_linkify_pull_request_url
    text = "https://github.com/rails/rails/pull/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/pull/21862)", filter(text)
  end

  def test_that_linkify_pull_request_url_with_end_tilde
    text = "https://github.com/rails/rails/pull/21862/"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/pull/21862)", filter(text)
  end

  def test_that_linkify_pull_request_url_with_www
    text = "https://www.github.com/rails/rails/pull/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/pull/21862)", filter(text)
  end

  def test_that_linkify_pull_request_url_http
    text = "http://github.com/rails/rails/pull/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/pull/21862)", filter(text)
  end

  def test_that_linkify_pull_request_url_http_www
    text = "http://www.github.com/rails/rails/pull/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/pull/21862)", filter(text)
  end

  def test_that_linkify_with_invalid_pull_request_url
    text = "https://github.com/rails/rails/pull/"

    assert_equal text, filter(text)
  end

  # == Issue

  def test_that_linkify_issue_url
    text = "https://github.com/rails/rails/issues/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/issues/21862)", filter(text)
  end

  def test_that_linkify_issue_url_with_end_tilde
    text = "https://github.com/rails/rails/issues/21862/"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/issues/21862)", filter(text)
  end

  def test_that_linkify_issue_url_with_www
    text = "https://www.github.com/rails/rails/issues/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/issues/21862)", filter(text)
  end

  def test_that_linkify_issue_url_http
    text = "http://github.com/rails/rails/issues/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/issues/21862)", filter(text)
  end

  def test_that_linkify_issue_url_http_www
    text = "http://www.github.com/rails/rails/issues/21862"

    assert_equal "[rails/rails#21862](https://github.com/rails/rails/issues/21862)", filter(text)
  end

  def test_that_linkify_with_invalid_issue_url
    text = "https://github.com/rails/rails/issues/"

    assert_equal text, filter(text)
  end

    # == Commit

  def test_that_linkify_commit_url
    text = "https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864"

    assert_equal "[rails/rails@`67597e1`](https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864)", filter(text)
  end

  def test_that_linkify_commit_url_with_end_tilde
    text = "https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864/"

    assert_equal "[rails/rails@`67597e1`](https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864)", filter(text)
  end

  def test_that_linkify_commit_url_with_www
    text = "https://www.github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864"

    assert_equal "[rails/rails@`67597e1`](https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864)", filter(text)
  end

  def test_that_linkify_commit_url_with_http
    text = "http://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864"

    assert_equal "[rails/rails@`67597e1`](https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864)", filter(text)
  end

  def test_that_linkify_commit_url_with_http_www
    text = "http://www.github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864"

    assert_equal "[rails/rails@`67597e1`](https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864)", filter(text)
  end

  def test_that_linkify_with_invalid_commit_url
    text = "http://www.github.com/rails/rails/commit/"

    assert_equal text, filter(text)
  end
end
