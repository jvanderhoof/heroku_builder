module HerokuBuilder
  class Base
    def conn
      unless ENV['HEROKU_API_KEY']
        fail 'No Heroku API Key found, please set it using the HEROKU_API_KEY environment variable'
      end
      @conn ||= ::PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
    end
  end
end
