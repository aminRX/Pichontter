require 'spec_helper'

describe "Authentication" do
	subject { page }
  describe "Signin page" do
  	it { should have_selector('h1', text: 'Sign in') }
  	it { should have_selector('title', text: 'Sign in') }
  end
end
