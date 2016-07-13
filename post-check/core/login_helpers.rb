require 'ostruct'
require 'spec_helper'

module LoginHelpers
  extend Capybara::DSL

  attr_reader :current_user

  def load_profile(name)
    OpenStruct.new(Configuration[:users].fetch(name.to_sym))
  end

  def login
    visit Capybara.app_host
  end

  def login_as usertype
    # ensure_on '/'
    visit Capybara.app_host
    commondata = OpenStruct.new(Configuration[:commondata])
    page.driver.browser.manage.window.maximize
    user = commondata[usertype]

    find(:xpath,"//input[@name='login']").set user[:username]
    find(:xpath,"//input[@name='password']").set user[:password]
    find(:xpath,"//button[.='Login']").click
  end

  def logout
    find(:xpath,"//a[contains(text(),'Sign Out')]").click
    p "Log out MRM"
  end

  def save_screenshot e
    @mutex.synchronize do
      name = e.description.gsub(" ","_")
      name = name.gsub("/","_")
      name = name + ".png"
      file_path=File.join(File.dirname(__FILE__), "../screen/#{name}")
      page.driver.browser.save_screenshot(file_path)
    end
  end
end