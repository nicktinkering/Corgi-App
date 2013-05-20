require 'spec_helper'

describe "AuthenticationPages" do

	subject { page }

	describe "the sign-in page" do
		before { visit signin_path }

		it { should have_selector('h1', text: 'Sign in') }
		it { should have_selector('title', text: 'Sign in') }
	end

	describe "signing in" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_selector('title', text: 'Sign in') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe "after visiting a different page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do 
				fill_in "Email", with: user.email.upcase
				fill_in "Password",	with: user.password
				click_button "Sign in"
			end

			it { should have_selector('title', text: user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signing out" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end

		end
	end

	describe "accessing restricted pages:" do

		describe "non-signed-in users," do
			let(:user) { FactoryGirl.create(:user) }

			describe "(in the Users controller)" do
				
				describe "visiting the edit page" do
					before { get edit_user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "submitting the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end
			end

			describe "after signing in, should be redirected to their original request path;" do
				describe "for example, trying to access the edit page:" do
					before do
						visit edit_user_path(user)
						sign_in user, skip_visit_signin: true
					end
					it { should be_user_edit_page }
				end
			end

		end

		describe "for incorrect users" do
			
			describe "in the Users controller" do
				let(:other_user) { FactoryGirl.create(:user) }
				let(:user_trying_to_edit_other_user) { FactoryGirl.create(:user, email: "whatajerk@example.com") }

				before { sign_in user_trying_to_edit_other_user }

				describe "visiting the edit page" do
					before { visit edit_user_path(other_user) }
					it { should_not be_user_edit_page }
				end

				describe "submitting the update action" do
					before { put user_path(other_user) }
					specify { response.should redirect_to(root_path) }				
				end
			end
		end
	end
end