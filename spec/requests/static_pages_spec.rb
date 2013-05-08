require 'spec_helper'

describe "Static Pages" do

	before(:each) do
		@base_title = "CorgiApp"
	end

	describe "Home page" do
		it "should have the default title" do
			visit home_path
			page.should have_selector('title', :text => "#{@base_title}")
		end
	end

	describe "Help page" do
		it "should have Help title" do
			visit help_path
			page.should have_selector('title', :text => "#{@base_title} | Help")
		end
	end

	describe "About page" do
		it "should have the About title" do
			visit about_path
			page.should have_selector('title', :text => "#{@base_title} | About")
		end
	end

	describe "Contact page" do
		it "should have the Contact title" do
			visit contact_path
			page.should have_selector('title', :text => "#{@base_title} | Contact")
		end
	end
end