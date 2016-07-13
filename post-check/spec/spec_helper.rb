require 'capybara'
require 'capybara/rspec'
require 'capybara/dsl'
require 'selenium/webdriver'
require 'rspec/retry'
require 'csv'
ENV['DEMO_ENV'] ||= 'staging'
ENV['BROWSER'] ||= 'firefox'
ENV['ROOT'] ||= File.expand_path('../../', __FILE__)
ENV['DOWNLOAD'] = File.join(ENV['ROOT'],"spec/support/data/downloaded_file")

Capybara.configure do |config|

  config.app_host = case ENV['DEMO_ENV']
                      when 'production'
                          'http://www.baidu.com'
                      when 'staging' then
                          'https://www.baidu.com'
                      else
                        raise "unknown environment: #{ENV['DEMO_ENV']}"
                    end
  # config.default_driver = :selenium
  # config.default_wait_time = 10 # seconds
end

 Capybara.register_driver :selenium do |app|
       case ENV['BROWSER']
       when 'chrome'
            prefs = {
              :download => {
                :prompt_for_download => false,
                :default_directory => ENV['DOWNLOAD']
              }
            }

            Capybara::Selenium::Driver.new(app, :browser => :chrome, :prefs => prefs)
       when 'firefox'
            profile = Selenium::WebDriver::Firefox::Profile.new
            profile['browser.download.folderList']=2
            profile['browser.download.manager.showWhenStarting']=false
            profile['browser.download.panel.show']=false
            profile['browser.download.panel.shown']=false
            profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv'
            profile['browser.download.dir']=ENV['DOWNLOAD']
            profile.secure_ssl = false
            profile.assume_untrusted_certificate_issuer = false
            Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
            # Capybara::Selenium::Driver.new(app, :browser => :firefox)
       end
  end

Dir[File.join(File.dirname(__FILE__), "../core/*.rb")].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  #Common Modules
  config.include Capybara::DSL
  config.include NavigationHelpers
  config.include LoginHelpers
  config.include Common
  config.include LogFactory

  config.color = true
  config.verbose_retry = true
  config.default_retry_count = 1

  config.before(:all) do
    pc_logger("debug")
    pre_write_log
  end

  config.before(:each) do |e|
    if e.description.split("-").length > 1
    @case_name_array << e.description.split("-")[0]
    @case_owner_array << e.description.split("-")[1]
    else
    @case_name_array << e.description
    @case_owner_array << "Null"
    end  
    @case_path_array << e.file_path
    @case_result_array << e.execution_result
  end

  config.after(:each) do |e|
    save_screenshot e
  end

  config.after(:all) do
    #save_screenshot
    after_write_log
  end
end


# class MaxWidow
#   include Capybara::DSL
# end

# MaxWidow.new.page.driver.browser.manage.window.maximize