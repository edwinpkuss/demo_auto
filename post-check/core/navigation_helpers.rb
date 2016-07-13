module NavigationHelpers

  def click_top_menu menu_name
    find(:xpath,"//ul[contains(@class,'nav-pills')]//a[text()='#{menu_name}']").click
  end

  def click_advertising_tab
    click_top_menu 'Advertising'
    p "Forward to Advertising Tab"
  end

  def ensure_on(path)
    visit path unless current_path == path
  end

end
