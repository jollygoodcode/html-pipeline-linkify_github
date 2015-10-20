require "test_helper"
require "html/pipeline"
require "html/pipeline/linkify_github"
require "github/markdown"

class HTML::Pipeline::LinkifyGitHubIntegrationTest < Minitest::Test
  def pipeline
    @pipeline ||= HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::LinkifyGitHubFilter
    ]
  end

  def test_works_with_markdown_filter
    result = pipeline.call <<-MARKDOWN.strip_heredoc
      https://github.com/rails/rails/pull/21862
      https://github.com/rails/rails/issues/21843
      https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864
    MARKDOWN

    assert_equal "<p><a href=\"https://github.com/rails/rails/pull/21862\">rails/rails#21862</a><br>\n<a href=\"https://github.com/rails/rails/issues/21843\">rails/rails#21843</a><br>\n<a href=\"https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864\">rails/rails@<code>67597e</code></a></p>",
                 result[:output].to_html
  end

  def test_works_when_markdown_already_linkified
    result = pipeline.call <<-MARKDOWN.strip_heredoc
      - [rails/rails#21862](https://github.com/rails/rails/pull/21862)
    MARKDOWN

    assert_equal "<ul>\n<li><a href=\"https://github.com/rails/rails/pull/21862\">rails/rails#21862</a></li>\n</ul>",
                 result[:output].to_html
  end

  def test_preserve_tags_inside_link
    result = pipeline.call <<-MARKDOWN.strip_heredoc
      - [**rails/rails#21862**](https://github.com/rails/rails/pull/21862)
    MARKDOWN

    assert_equal "<ul>\n<li><a href=\"https://github.com/rails/rails/pull/21862\"><strong>rails/rails#21862</strong></a></li>\n</ul>",
                 result[:output].to_html
  end
end
