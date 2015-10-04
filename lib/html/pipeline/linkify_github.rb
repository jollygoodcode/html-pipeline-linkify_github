require "html/pipeline"

module HTML
  class Pipeline
    # Filter that converts GitHub's url into friendly markdown.
    #
    # For example:
    #
    #   https://github.com/rails/rails/pull/21862
    #   https://github.com/rails/rails/issues/21843
    #   https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864
    #
    #   =>
    #
    #   [rails/rails#21862](https://github.com/rails/rails/pull/21862)
    #   [rails/rails#21843](https://github.com/rails/rails/issues/21843)
    #   [rails/rails@`67597e`](https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864)
    #
    # This filter does not write any additional information to the context hash.
    class LinkifyGitHubFilter < TextFilter
      GITHUB_URL = "github.com".freeze
      PULL = "/pull/".freeze
      ISSUES = "/issues/".freeze
      COMMIT = "/commit/".freeze

      PULL_REQUEST_REGEXP = %r{https?://(www.)?github.com/(?<owner>.+)/(?<repo>.+)/pull/(?<number>\d+)/?}.freeze
      ISSUES_REGEXP = %r{https?://(www.)?github.com/(?<owner>.+)/(?<repo>.+)/issues/(?<number>\d+)/?}.freeze
      COMMIT_REGEXP = %r{https?://(www.)?github.com/(?<owner>.+)/(?<repo>.+)/commit/(?<number>\w+)/?}.freeze

      # Convert GitHub urls into friendly markdown.
      def call
        return @text unless @text.include?(GITHUB_URL)

        replace_pull_request_links if has_pull_request_link?
        replace_issue_links if has_issue_link?
        replace_commit_links if has_commit_link?

        @text
      end

      private

        def has_pull_request_link?
         @text.include?(PULL)
        end

        def has_issue_link?
          @text.include?(ISSUES)
        end

        def has_commit_link?
          @text.include?(COMMIT)
        end

        def replace_pull_request_links
          @text.gsub!(PULL_REQUEST_REGEXP) do
            pull_request_markdown($1, $2, $3) if [$1, $2, $3].all?(&:present?)
          end
        end

        def replace_issue_links
          @text.gsub!(ISSUES_REGEXP) do
            issue_markdown($1, $2, $3) if [$1, $2, $3].all?(&:present?)
          end
        end

        def replace_commit_links
          @text.gsub!(COMMIT_REGEXP) do
            commit_markdown($1, $2, $3) if [$1, $2, $3].all?(&:present?)
          end
        end

        def pull_request_markdown(repo, owner, number)
          "[#{repo}/#{owner}##{number}](https://github.com/#{repo}/#{owner}/pull/#{number})"
        end

        def issue_markdown(repo, owner, number)
          "[#{repo}/#{owner}##{number}](https://github.com/#{repo}/#{owner}/issues/#{number})"
        end

        def commit_markdown(repo, owner, number)
          "[#{repo}/#{owner}@`#{number[0..6]}`](https://github.com/#{repo}/#{owner}/commit/#{number})"
        end
    end
  end
end
