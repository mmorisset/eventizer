require 'spec_helper'

describe Project do

  describe "Factory" do
    it { build(:project).should be_valid }
  end

  describe 'fields' do
    it { should have_field(:name).of_type(String) }
  end
  
  describe 'validations' do
    it { should validate_presence_of(:user) }
  end

  describe "Associations" do
    it { should belong_to(:user).as_inverse_of(:projects)}
    it { should have_many(:event_collections).as_inverse_of(:project) }
  end
end