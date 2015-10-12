# ENV variables
module HerokuBuilder
  class EnvVars < Base
    def config_vars(name)
      @config_vars ||= conn.config_var.info(name)
    end

    def set_config_vars(name, config_vars)
      conn.config_var.update(name, config_vars)
    end

    def diff_config_vars(current, proposed)
      diffs = HashDiff.diff(current, proposed)
      diffs.select { |i| i.first.match(/~|\+/) }.map do |diff|
        if diff.first == '~'
          "Updating #{diff[1]} from: '#{diff[2]}' to: '#{diff[3]}'"
        else
          "Adding #{diff[1]} with: '#{diff[2]}'"
        end
      end
    end

    def config_env_changes(name, config_vars)
      diff_config_vars(config_vars(name), config_vars)
    end
  end
end
