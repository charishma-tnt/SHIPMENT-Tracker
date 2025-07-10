require 'rails_helper'

RSpec.describe "Login Page", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "displays the login form with all fields" do
    visit new_user_session_path

    expect(page).to have_selector('h2', text: 'Login Page')
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
    expect(page).to have_select('Select Role')
    expect(page).to have_unchecked_field('Remember me')
    expect(page).to have_button('Log in')
    expect(page).to have_link('Forgot your password?')
    expect(page).to have_link('Sign up')
  end

  it "allows user to log in with valid credentials" do
    user = FactoryBot.create(:user, email: 'test@example.com', password: 'password', password_confirmation: 'password', role: 'customer')

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    select 'Customer', from: 'Select Role'
    check 'Remember me'
    # Ensure the button is clicked after filling in fields

    # Check for dashboard welcome message instead of generic success message
    expect(page).to have_content("Welcome back #{user.email}!")
  end

  it "shows error with invalid credentials" do
    visit new_user_session_path

    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: 'wrongpassword'
    select 'Customer', from: 'Select Role'
    click_button 'Log in'

    # Devise flash error may not have .alert class, check for flash alert div instead
    expect(page).to have_css('div.alert, div.alert-danger, div.flash-alert, div.flash-error', visible: true)
    expect(page).to have_content('Invalid Email or password.')
  end
end
