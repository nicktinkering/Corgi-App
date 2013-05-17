# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

require 'spec_helper'

describe User do

	before { @user = User.new(name: "Example User", email: "example@ex.org",
							  password: "foobar", 	password_confirmation: "foobar") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }

	it { should be_valid }

	describe ": attributes:" do
			describe "the name:" do
				describe "when it is left blank" do
					before { @user.name = " " }
					it { should_not be_valid }
				end

				describe "when it is too long" do
					before { @user.name = "a" * 51 }
					it { should_not be_valid }
				end
			end

			describe "the email:" do
				describe "when it is left blank" do
					before { @user.email = " " }
					it { should_not be_valid }
				end

				describe "the format" do
					describe "when it is invalid" do
						it "should be invalid" do
							addresses = %w[user@foo,com user_at_foo.org example.user@foo.
				                     foo@bar_baz.com foo@bar+baz.com]

							addresses.each do |invalid_address|
								@user.email = invalid_address
								@user.should_not be_valid
							end
						end
					end

					describe "when it is valid" do
						it "should be valid" do
							addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

							addresses.each do |valid_address|
								@user.email = valid_address
								@user.should be_valid
							end
						end
					end
				end

				before { @duplicate_user = @user.dup }

				describe "when the email address is already in use" do
					describe "and the duplicate is an exact match" do
						before {
							@duplicate_user.save
						}

						it { should_not be_valid }
					end

					describe "and the duplicate has different capitalization" do
						before {
							@user.email.downcase!
							@duplicate_user.email.upcase!
							@duplicate_user.save
						}

						it { should_not be_valid }
					end
				end	
			end

			describe "the password:" do
				describe "when it is left blank" do
					before { @user.password = @user.password_confirmation = " " }
					it { should_not be_valid }
				end

				describe "when it is too short" do
					before { @user.password = @user.password_confirmation = "a" * 4 }
					it { should_not be_valid }
				end

				describe "when it does not match the confirmation" do
					before { @user.password_confirmation = "not the same" }
					it { should_not be_valid }
				end

				describe "the confirmation is nil" do
					before { @user.password_confirmation = nil }
					it { should_not be_valid }
				end
			end

			describe "the remember token:" do
				before { @user.save }
				its(:remember_token) { should_not be_blank }
			end
	end

	describe ": methods:" do
		describe "authenticate:" do
			describe "the return value" do
				before { @user.save }
				let(:db_user_with_that_email) { User.find_by_email(@user.email) }

				describe "with a valid password" do
					it { should == db_user_with_that_email.authenticate(@user.password) }
				end

				describe "with an invalid password" do
					let(:return_value_for_invalid_password) { db_user_with_that_email.authenticate("invalid password") }

					it { should_not == return_value_for_invalid_password }
					specify { return_value_for_invalid_password.should be_false }
				end
			end
		end
	end 

end
