# Add Ons
module HerokuBuilder
  class AddOn < Base
    def addon_list(name)
      conn.addon.list_by_app(name)
    end

    def addon_exists?(name, addon_name)
      addon_list(name).any? do |a|
        # names appear to be stored in two different locations depending on the type
        (!addon_name.include?(':') && a['addon_service']['name'] == addon_name) ||
          a['plan']['name'] == addon_name
      end
    end

    def set_addons(name, addons)
      addons.each do |addon|
        unless addon_exists?(name, addon)
          conn.addon.create(name, 'plan' => addon)
        end
      end
    end
  end
end
