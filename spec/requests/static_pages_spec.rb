require 'spec_helper'

describe "Static Pages" do

	describe "Home page" do
		it "should have the default title" do
			visit '/static_pages/home'
			page.should have_selector('title', :text => "CorgiApp")
		end
	end

	describe "Help page" do
		it "should have Help title" do
			visit '/static_pages/help'
			page.should have_selector('title', :text => "CorgiApp | Help")
		end
	end

	describe "About page" do
		it "should have the About title" do
			visit '/static_pages/about'
			page.should have_selector('title', :text => "CorgiApp | About")
		end
	end

	describe "Contact page" do
		it "should have the Contact title" do
			visit '/static_pages/contact'
			page.should have_selector('title', :text => "CorgiApp | Contact")
		end
	end
end