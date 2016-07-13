require 'spec_helper'
require 'ostruct'
include DemoAction

feature 'Add_Advertiser', :js do

  before :all do
  	demo = OpenStruct.new(Configuration[:demo])
    @keyword = demo[:keyword]
  end

  before :each do
  	login
  end

 

  describe "Input keyword in baidu search" do

     it 'test search keyword', :p1 do
     	input_keyword @keyword
     	click_search_button
    end
  end
end
