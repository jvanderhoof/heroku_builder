# Resources
module HerokuBuilder
  class Resource < Base
    def update_resource(name, type, size, count)
      config_hsh = {
        'size' => size.capitalize,
        'quantity' => count.to_i
      }
      conn.formation.update(name, type, config_hsh)
    end

    def get_formation(name, type)
      conn.formation.list(name).detect { |formation| formation['type'] == type }
    end

    def set_resources(name, resources)
      resources.each do |type, config|
        h_resource = get_formation(name, type)
        if h_resource['size'] != config['type'].capitalize ||
           h_resource['quantity'].to_i != config['count'].to_i
          update_resource(name, type, config['type'], config['count'])
        end
      end
    end
  end
end
