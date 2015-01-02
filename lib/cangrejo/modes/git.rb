require "git"
require "cangrejo/modes/local"

module Cangrejo
  module Modes
    class Git < Local

      def initialize(_url, _commit, _relative_path, _name=nil)
        @url = _url
        @commit = _commit
        @relative_path = _relative_path
        @needs_bundle = false
        @name = _name || Digest::MD5.hexdigest(@url)
        super deploy_path
      end

      def setup
        ensure_repo_clone
        ensure_repo_commit
        ensure_deps
        super
      end

    private

      def deploy_path
        if @relative_path.present?
          File.join repo_path, @relative_path
        else
          repo_path
        end
      end

      def cache_path
        Cangrejo.config.crawler_cache_path
      end

      def repo_path
        File.join cache_path, @name
      end

      def ensure_repo_clone
        unless File.exists? File.join(repo_path, '.git')
          ::Git.clone(@url, @name, :path => cache_path)
          @needs_bundle = true
        end
      end

      def ensure_repo_commit
         g = ::Git.open repo_path
         if g.log.first.sha != @commit
          g.fetch
          g.checkout @commit
          @needs_bundle = true
         end
      end

      def ensure_deps
        %x[cd '#{deploy_path}' && bundle install] if @needs_bundle
        @needs_bundle = false
      end
    end
  end
end