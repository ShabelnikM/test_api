Apipie.configure do |config|
  config.app_name                = 'RubyGarageTestApi'
  config.copyright               = '&copy; 2019 Maksym Shabelnyk'
  config.api_base_url            = '/api/'
  config.doc_base_url            = '/apipie'
  config.translate               = false
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.app_info['1.0']         = 'Test unit API for RubyGarage by Maksym Shabelnyk'
end
