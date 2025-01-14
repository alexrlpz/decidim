# frozen_string_literal: true

shared_context "when inviting process users" do
  let(:participatory_process) { create(:participatory_process) }
  let(:organization) { participatory_process.organization }
  let(:user) { create(:user, :admin, :confirmed, organization: participatory_process.organization) }
  let(:email) { "this_email_does_not_exist@example.org" }

  def invite_user
    login_as user, scope: :user

    visit decidim_admin_participatory_processes.participatory_process_user_roles_path(participatory_process)
    within "[data-content]" do
      click_on "New process admin"
    end

    fill_in "Name", with: "Alice Liddel"
    fill_in "Email", with: email
    select role, from: "Role"
    click_on "Create"
    expect(page).to have_content("successfully added to this participatory process")
    logout :user
    visit decidim.root_path
    expect(page).to have_content(translated(organization.name))
  end

  def edit_user(username)
    login_as user, scope: :user

    visit decidim_admin_participatory_processes.participatory_process_user_roles_path(participatory_process)

    within "tr", text: username do
      click_on "Edit"
    end
  end
end
