module DemoAction
	def input_keyword keyword
		find(:xpath, "//input[@id='kw']").set keyword
		p "input keyword #{keyword}"
	end

	def click_search_button
		find(:xpath, "//input[@id='su']").click
	end

end