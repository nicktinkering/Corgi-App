# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

	before { @user = User.new(name: "Example User", email: "example@ex.org") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }

	it { should be_valid }

	describe "when name is left blank" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when email is left blank" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when the email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]

			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when the email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]

			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
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
