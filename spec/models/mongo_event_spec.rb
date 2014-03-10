require 'spec_helper'

describe MongoEvent do

  describe "Factory" do
    it { build(:mongo_event).should be_valid }
  end

  describe "Attributes" do
    it { should be_timestamped_document }

  # Custom fields
    # it { should have_field(:name).of_type(String) }

  # describe "Associations" do
  end

  describe "Validations" do
    # Devise fields
    # it { should validate_presence_of(:email)                          }
    # it { should validate_format_of(:email)                            }
    # it { should validate_presence_of(:encrypted_password)             }
    # it { should validate_presence_of(:password)                       }
    # it { should validate_confirmation_of(:password)                   }
    # it { should validate_length_of(:password).within(6..128)          }
  end
end