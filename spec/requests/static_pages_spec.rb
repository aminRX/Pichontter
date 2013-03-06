require 'spec_helper'

describe "Static pages" do
	let(:base_title) { "Pichontter" }
	describe "Home page" do

		it "should have the h1 'Pichontter'" do
			visit '/static_pages/home'
			page.should have_selector('h1',
									:text => "#{base_title}")
		end

		it "should have right title" do
			visit '/static_pages/home'
			page.should have_selector('title',
									:text => "#{base_title} | Home")
		end
	end

	describe "Help page" do
		it "should have the h1 'Help'" do
			visit '/static_pages/help'
			page.should have_selector('h1',
									:text => 'Help')
		end
		it "should have right title" do
			visit '/static_pages/help'
			page.should have_selector('title',
									:text => "#{base_title} | Help")
		end
	end

	describe "About page" do
		it "should have the h1 'About Us'" do
			visit '/static_pages/about'
			page.should have_selector('h1',
									:text => 'About Us')
		end
		it "should have right title" do
			visit '/static_pages/about'
			page.should have_selector('title',
									:text => "#{base_title} | About Us")
		end
	end
	describe "Contact" do
		it "should have the h1 'Contact'" do
			visit '/static_pages/contact'
			page.should have_selector('h1',
				           			:text => 'Contact')
		end
		it "should have right title" do
			visit '/static_pages/contact'
			page.should have_selector('title',
									:text => "#{base_title} | Contact")
		end
	end
end