require 'spec_helper'

describe Authorization do

  describe "Factory" do
    it { build(:master_authorization).should be_valid }
    it { build(:write_authorization).should be_valid }
    it { build(:read_authorization).should be_valid }
  end

  describe 'fields' do
    it { should have_field(:name).of_type(String) }
    it { should have_field(:access).of_type(String) }
    it { should have_field(:secret).of_type(String) }
  end
  
  describe 'validations' do
    it { should validate_uniqueness_of(:secret) }
  end

  describe "Associations" do
    it { should belong_to(:user).as_inverse_of(:authorizations)}
  end

  describe 'secret generation' do
    it 'should generate secret' do 
      authorization = create(:master_authorization)
      authorization.secret.should_not be_nil
    end
  end
end
