require 'spec_helper'

describe "User pages" do
	subject { page }
	describe "signup page" do
		before { visit singup_path }
		it { should have_selector('h1', text: 'Sing up') }
		it { should have_selector('title', text: full_title('Sing up')) }
	end
	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }
	end
	describe "sing up" do
		before { visit singup_path }
		let (:submit) { "Create my account" }
		describe "With invalid information" do
			describe "after submission" do
				before { click_button submit }
				it { should have_selector('title', text: full_title('Sing up')) }
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
  			end
		end
	end
end