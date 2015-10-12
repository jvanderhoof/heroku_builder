module HerokuBuilder
  class Base
    def conn
      @conn ||= ::PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
    end
  end
end
