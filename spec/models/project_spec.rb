# frozen_string_literal: true

require "rails_helper"

RSpec.describe Project, type: :model do
  describe "#description" do
    it "is nil by default" do
      expect(described_class.new.description).to be_nil
    end

    it "is the associated rubygem's description when present" do
      project = described_class.new rubygem: Rubygem.new(description: "Hello World!")
      expect(project.description).to be == "Hello World!"
    end
  end

  it "does not allow mismatches between permalink and rubygem name" do
    project = Project.create! permalink: "simplecov"
    expect { project.update_attributes! rubygem_name: "rails" }.to raise_error(
      ActiveRecord::StatementInvalid,
      /check_project_permalink_and_rubygem_name_parity/
    )
  end

  describe "#github_only?" do
    it "is false when no / is present in permalink" do
      expect(Project.new(permalink: "foobar")).not_to be_github_only
    end

    it "is true when a / is present in permalink" do
      expect(Project.new(permalink: "foo/bar")).to be_github_only
    end
  end

  describe "#path=" do
    it "normalizes the path to the stripped, downcase variant" do
      expect(Project.new(github_repo_path: " FoO/BaR ").github_repo_path).to be == "foo/bar"
    end
  end
end