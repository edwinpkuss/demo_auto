require 'ostruct'

module Common
  extend Capybara::DSL
  # TIMESTAMP = Time.new.strftime("%Y-%m-%d %H:%M:%S")
  TIMESTAMP = Time.new.strftime("%Y%m%d%H%M%S")
  DATE = Time.new.strftime("%m/%d/%Y")
  def find_and_click xpath
  	find(:xpath, xpath).click
  end
  
  def wait_for_ajax(&block)
	  sleep 1
	  Selenium::WebDriver::Wait.new(:timeout => 5).until { page.driver.browser.execute_script("return jQuery.active == 0") }
	  yield if block_given?
  end

  def wait_for_page(&block)
    Selenium::WebDriver::Wait.new(:timeout => 5) { page.driver.browser.execute_script("return document.readyState") == 'complete' }
    wait_for_ajax
    yield if block_given?
  end

  def refresh_current_page
    page.driver.browser.navigate.refresh
    wait_for_ajax
    p "refresh page successfully"
  end

  def delete_downloaded_files(pattern)
    download_path = ENV['ROOT'] + "/spec/support/data/downloaded_file/"
    system("cd #{download_path};rm *#{pattern}*")
  end

  def maximize_window
    page.driver.browser.manage.window.maximize
  end

  def sleep_for_environment
    sleep 20
  end
end
