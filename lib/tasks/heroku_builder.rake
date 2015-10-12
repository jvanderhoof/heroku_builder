require 'heroku_builder'

namespace :builder do
  # Utility functions from development
  # These may be removed...
  def pretty_print(hsh)
    hsh.keys.sort.each do |key|
      puts "#{key}: #{hsh[key].inspect}"
    end
  end

  # Rake setup
  HerokuBuilder::Service.config_file.keys.each do |env|
    namespace env.to_sym do
      task :update do
        HerokuBuilder::Service.process(env)
      end

      # task :plan do
      #   changes('backstage').each do |change|
      #     puts change
      #   end
      # end
    end
  end

end
