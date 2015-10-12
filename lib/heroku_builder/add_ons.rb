# Add Ons
module HerokuBuilder
  class AddOns < Base
    def addons(name)
      conn.addon.list_by_app(name)
    end

    def addon_exists?(name, addon_name)
      conn.addon.list_by_app(name).any? do |a|
        # names appear to be stored in two different locations depending on the type
        (!addon_name.include?(':') && a['addon_service']['name'] == addon_name) ||
          a['plan']['name'] == addon_name
      end
    end

    def set_addons(name, addons)
      addons.each do |addon|
        unless addon_exists?(name, addon)
          puts "... adding #{addon}"
          conn.addon.create(name, 'plan' => addon)
        end
      end
    end
  end
end
