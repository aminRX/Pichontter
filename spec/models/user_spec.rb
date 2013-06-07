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
	before do
		@user = User.new(name: "Amin Ogarrio", email: "amin.2_@gmail.com",
						password: "cacatua", password_confirmation: "cacatua")
	end
	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should be_valid }

	describe " When name is blank  " do
		before { @user.name = "  "}
		it { should_not be_valid }
	end
	describe " email blank " do
		before { @user.email = "  " }

		it { should_not be_valid }
	end

	describe " When name is too long " do
		before { @user.name = "a" * 51 }

		it { should_not be_valid }
	end

	describe " invalid email " do
		it " should be invalid " do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                    foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |address|
				@user.email = address
				@user.should_not be_valid
			end
		end
	end

	describe " valid email " do
		it " should be valid " do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |address|
				@user.email = address
				@user.should be_valid
			end
		end
	end
	describe " When email is taken " do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		it { should_not be_valid }
	end

	describe " When the password isnt blank " do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe " password not match " do
		before { @user.password_confirmation = "notmatch" }
		it { should_not be_valid }
	end
	describe " When password is nil " do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end
	describe " short password " do
		before { @user.password = @user.password_confirmation = 'a' * 5 }
		it { should_not be_valid }
	end
	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }
		describe " With valid password " do
			it { should == found_user.authenticate(@user.password) }
		end
		describe " With invalid password " do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end
	describe "remember token" do
		before { @user.save }
		its(:remember_token) { should_not be_blank }
	end

end

