def sign_in(user, options = {})
	options.reverse_merge! skip_visit_signin: false

	visit signin_path unless options[:skip_visit_signin]

	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :be_user_edit_page do
	match do |page| 
		page.should have_selector('title', text: 'Update Profile')
	end
end