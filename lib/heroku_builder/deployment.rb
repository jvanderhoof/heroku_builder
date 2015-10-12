# Deployment
module HerokuBuilder
  class Deployment < Base
    def remote_exists?(branch)
      git.remotes.detect { |remote| remote.name == branch }.nil?
    end

    def push(name, branch, environment)
      remote_branch = "heroku-#{environment}"
      if remote_exists?(remote_branch)
        git.add_remote(remote_branch, app(name)['git_url'])
      end
      git.push(remote_branch, "#{branch}:master")
      puts "remotes: #{git.remotes.map(&:name)}"
    end

    def git
      @git ||= Git.open('.', log: Logger.new(STDOUT))
    end

    def deploy(name, branch, environment)
      checkout(branch)
      push(name, branch, environment)
    end

    def checkout(branch)
      git.fetch
      git.checkout(branch)
      git.pull('origin', branch)
    end
  end
end
