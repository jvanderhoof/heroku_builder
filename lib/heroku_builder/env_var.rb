# ENV variables
module HerokuBuilder
  class EnvVar < Base
    def get_config_vars(name)
      @config_vars ||= conn.config_var.info(name)
    end

    def set_config_vars(name, config_vars)
      env_vars = config_vars
      if config_vars.is_a? Array
        env_vars = {}.tap do |hsh|
          config_vars.each do |args|
            hsh.merge!(args)
          end
        end
      end
      conn.config_var.update(name, env_vars)
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
      diff_config_vars(get_config_vars(name), config_vars)
    end
  end
end
