# frozen_string_literal: true

require "spec_helper"

describe Decidim::Debates::Admin::DebateForm do
  subject(:form) { described_class.from_params(attributes).with_context(context) }

  let(:organization) { create(:organization) }
  let(:context) do
    {
      current_organization: organization,
      current_component:,
      current_participatory_space: participatory_process
    }
  end
  let(:participatory_process) { create(:participatory_process, organization:) }
  let(:current_component) { create(:component, participatory_space: participatory_process) }
  let(:title) do
    Decidim::Faker::Localized.sentence(word_count: 3)
  end
  let(:description) do
    Decidim::Faker::Localized.sentence(word_count: 3)
  end
  let(:instructions) do
    Decidim::Faker::Localized.sentence(word_count: 3)
  end
  let(:start_time) { 2.days.from_now }
  let(:end_time) { 2.days.from_now + 4.hours }
  let(:taxonomies) { [] }
  let(:attributes) do
    {
      taxonomies:,
      title:,
      description:,
      instructions:,
      start_time:,
      end_time:
    }
  end

  describe "taxonomies" do
    let(:component) { current_component }
    let(:participatory_space) { participatory_process }

    it_behaves_like "a taxonomizable resource"
  end

  it { is_expected.to be_valid }

  describe "when title is missing" do
    let(:title) { { ca: nil, es: nil } }

    it { is_expected.not_to be_valid }
  end

  describe "when description is missing" do
    let(:description) { { ca: nil, es: nil } }

    it { is_expected.not_to be_valid }
  end

  describe "when instructions is missing" do
    let(:instructions) { { ca: nil, es: nil } }

    it { is_expected.not_to be_valid }
  end

  describe "when start_time is missing" do
    let(:start_time) { nil }

    it { is_expected.not_to be_valid }
  end

  describe "when end_time is missing" do
    let(:end_time) { nil }

    it { is_expected.not_to be_valid }
  end

  describe "when both end_time and start_time are missing" do
    let(:end_time) { nil }
    let(:start_time) { nil }

    it { is_expected.to be_valid }
  end

  describe "when start_time is after end_time" do
    let(:start_time) { end_time + 3.days }

    it { is_expected.not_to be_valid }
  end

  describe "when end_time is before start_time" do
    let(:end_time) { start_time - 3.days }

    it { is_expected.not_to be_valid }
  end

  describe "when start_time is equal to start_time" do
    let(:start_time) { end_time }

    it { is_expected.not_to be_valid }
  end

  describe "from model" do
    subject { described_class.from_model(debate).with_context(context) }

    let(:component) { create(:debates_component) }
    let(:debate) { create(:debate, component:) }

    it "sets the finite value correctly" do
      expect(subject.finite).to be(false)
    end

    context "when the debate has start and end dates" do
      let(:debate) { create(:debate, :open_ama) }

      it "sets the finite value correctly" do
        expect(subject.finite).to be(true)
      end
    end
  end
end
