require "html/pipeline"

module HTML
  class Pipeline
    # Filter that converts GitHub's url into friendly markdown.
    #
    # For example:
    #
    #   <a href="https://github.com/rails/rails/pull/21862">https://github.com/rails/rails/pull/21862</a>
    #   <a href="https://github.com/rails/rails/issues/21843">https://github.com/rails/rails/issues/21843</a>
    #   <a href="https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864">https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864</a>
    #
    #   =>
    #
    #   <a href="https://github.com/rails/rails/pull/21862">rails/rails#21862</a>
    #   <a href="https://github.com/rails/rails/issues/21843">rails/rails#21843</a>
    #   <a href="https://github.com/rails/rails/commit/67597e1719ec6af7e22964603cc77aa5b085a864">rails/rails@`67597e`</a>
    #
    # This filter does not write any additional information to the context hash.
    class LinkifyGitHubFilter < Filter
      PULL_REQUEST_REGEXP = %r{https?://(www.)?github.com/(?<owner>.+)/(?<repo>.+)/pull/(?<number>\d+)/?}.freeze
      ISSUES_REGEXP = %r{https?://(www.)?github.com/(?<owner>.+)/(?<repo>.+)/issues/(?<number>\d+)/?}.freeze
      COMMIT_REGEXP = %r{https?://(www.)?github.com/(?<owner>.+)/(?<repo>.+)/commit/(?<number>\w+)/?}.freeze

      def call
        doc.search("a").each do |element|
          next if element.blank? || element.comment?
          next if element["href"].to_s.empty?

          text = element.inner_html

          element.inner_html = if is_a_pull_request_link? text
            replace_pull_request_link(text)
          elsif is_a_issue_link? text
            replace_issue_link(text)
          elsif is_a_commit_link? text
            replace_commit_link(text)
          else
            text
          end
        end

        doc
      end

      private

        def is_a_pull_request_link?(text)
          text.include?("/pull/".freeze)
        end

        def is_a_issue_link?(text)
          text.include?("/issues/".freeze)
        end

        def is_a_commit_link?(text)
          text.include?("/commit/".freeze)
        end

        def replace_pull_request_link(text)
          text.gsub(PULL_REQUEST_REGEXP) do
            pull_request_shorthand($1, $2, $3)
          end
        end

        def replace_issue_link(text)
          text.gsub(ISSUES_REGEXP) do
            issue_shorthand($1, $2, $3)
          end
        end

        def replace_commit_link(text)
          text.gsub(COMMIT_REGEXP) do
            commit_shorthand($1, $2, $3)
          end
        end

        def pull_request_shorthand(repo, owner, number)
          "#{repo}/#{owner}##{number}"
        end

        def issue_shorthand(repo, owner, number)
          "#{repo}/#{owner}##{number}"
        end

        def commit_shorthand(repo, owner, number)
          "#{repo}/#{owner}@`#{number[0..5]}`"
        end
    end
  end
end
