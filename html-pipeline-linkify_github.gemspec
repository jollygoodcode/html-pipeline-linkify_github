# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "html/pipeline/linkify_github/version"

Gem::Specification.new do |spec|
  spec.name          = "html-pipeline-linkify_github"
  spec.version       = HTML::Pipeline::LinkifyGitHub::VERSION
  spec.authors       = ["Juanito Fatas"]
  spec.email         = ["katehuang0320@gmail.com"]
  spec.summary       = %q{A HTML::Pipeline filter to autolink GitHub urls.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/juanitofatas/html-pipeline-linkify_github"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_dependency "html-pipeline", ">= 1.11"

  spec.required_ruby_version = "~> 2.0"
end
