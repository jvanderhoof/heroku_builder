module HerokuBuilder
  class App < Base
    def app_exists?(name)
      !conn.app.list.detect { |a| a['name'] == name }.nil?
    end

    def find_or_create_app(name)
      return app(name) if app_exists?(name)
      conn.app.create('name' => name, 'region' => 'us', 'stack' => 'cedar-14')
    end

    def app(name)
      if app_exists?(name)
        conn.app.info(name)
      else
        {}
      end
    end
  end
end
