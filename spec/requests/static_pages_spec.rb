require 'spec_helper'
include ApplicationHelper

describe "Static Pages" do

	subject { page }

	shared_examples_for "all static pages with titles" do
		it { should have_selector('title', :text => full_title(titlesuffix))}

	end

	describe "Home page" do
		before { visit root_path }

		let(:titlesuffix) { '' }
		it_should_behave_like "all static pages with titles"
	end

	describe "Help page" do

		before { visit help_path }

		let(:titlesuffix) { "Help" }
		it_should_behave_like "all static pages with titles"
	end

	describe "About page" do
		before { visit about_path }

		let(:titlesuffix) { "About" }
		it_should_behave_like "all static pages with titles"
	end

	describe "Contact page" do
		before { visit contact_path }

		let(:titlesuffix) { "Contact" }
		it_should_behave_like "all static pages with titles"
	end


	it "should have the right links on the layout" do
		visit root_path
		click_link "About"
		page.should have_selector 'title', text: full_title('About')
	end

end