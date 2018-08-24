module ValidUrl
  class Engine < ::Rails::Engine
    config.before_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end
  end
end
