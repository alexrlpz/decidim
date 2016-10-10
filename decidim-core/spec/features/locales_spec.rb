# frozen_string_literal: true
require "spec_helper"

describe "Locales", type: :feature do
  context "switching locales" do
    let(:organization) { create(:organization) }

    before do
      switch_to_host(organization.host)
      visit decidim.root_path
    end

    it "changes the locale to the chosen one" do
      click_link "Català"

      expect(page).to have_content("Benvingut/da a #{organization.name}")
    end

    it "keeps the locale between pages" do
      click_link "Català"
      click_link "Inici"

      expect(page).to have_content("Benvingut/da a #{organization.name}")
    end
  end
end
