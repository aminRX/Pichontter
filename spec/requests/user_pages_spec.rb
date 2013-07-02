require 'spec_helper'

describe "User pages" do
	subject { page }

	describe "signup page" do
		before { visit signup_path }
		it { should have_selector('h1', text: 'Sign up') }
		it { should have_selector('title', text: full_title('Sign up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	describe "sign up" do
		before { visit signup_path }
		let (:submit) { "Create my account" }
		describe "With invalid information" do
			describe "after submission" do
				before { click_button submit }
				it { should have_selector('title', text: full_title('Sign up')) }
				it { should have_content('error') }
			end
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end
		describe "With valid information" do
			before do
				fill_in "Name",				with: "Amin Ogarrio"
				fill_in "Email",			with: "amin.ogarrio@gmail.com"
				fill_in "Password",			with: "cacatua123"
				fill_in "Confirmation",		with: "cacatua123"
			end
			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
			describe "after saving the user" do
    			before { click_button submit }
    			let(:user) { User.find_by_email('amin.ogarrio@gmail.com') }
    			it { should have_selector('title', text: user.name) }
    			it { should have_selector('div.alert.alert-success', text: 'Welcome') }
    			it { should have_link('Sign out', href: signout_path) }
    			describe "followed by signout" do
  					before { click_link "Sign out" }
  					it { should have_link('Sign in') }
  				end
  			end

		end
	end

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end
		describe "page" do
			it { should have_selector('h1', text: 'Update your profile') }
			it { should have_selector('title', text: 'Edit user') }
			it { should have_link('change', href:'http://gravatar.com/emails') }
		end
		
		describe "with invalid information" do
			before { click_button "Save changes" }
			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_user) { "Edit User" }
			let(:new_email) { "edit_user@gmail.com" }
			before do
				fill_in "Name",				with: new_user
				fill_in "Email",			with: new_email
				fill_in "Password",			with: user.password
				fill_in "Confirm Password",	with: user.password_confirmation
				click_button "Save changes"
			end
			it { should have_selector('title', text: new_user) }
			it { should have_selector('div.alert.alert-success') }
			specify { user.reload.name.should == new_user }
			specify { user.reload.email.should == new_email }
		end
	end
	describe "index" do
		let(:user) { FactoryGirl.create(:user) }

		before(:each) do
			sign_in user
			visit users_path
		end

		it { should have_selector('title', text: 'All users') }
		it { should have_selector('h1', text: 'All users') }
		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all) { User.delete_all }
			it { should have_selector('div.pagination') }
			describe "should list each user" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li', text: user.name)
				end
			end
		end
		describe "delete links" do
			it { should_not have_link('delete') }
			describe "as a admin user" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					sign_in admin
					visit users_path
				end
				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)
				end
				it { should_not have_link('delete', href: user_path(admin)) }
			end
		end
	end
end