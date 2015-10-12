module HerokuBuilder
  class App < Base
    def app_exists?(name)
      !conn.app.list.detect { |a| a['name'] == name }.nil?
    end

    def find_or_create_app(name)
      return if app_exists?(name)
      conn.app.create(name: name, region: 'us', stack: 'cedar')
    end

    def app(name)
      @app ||= conn.app.info(name)
    end
  end
end
