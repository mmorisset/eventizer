require 'spec_helper'

describe User do

  describe "Factory" do
    it { build(:user).should be_valid }
  end

  # describe "Attributes" do
  #   it { should be_timestamped_document }

  #   # Devise fields
    it { should have_field(:email).of_type(String) }
    it { should have_field(:encrypted_password).of_type(String) }
    it { should have_field(:remember_created_at).of_type(Time) }
    it { should have_field(:sign_in_count).of_type(Integer).with_default_value_of(0) }
    it { should have_field(:current_sign_in_at).of_type(Time) }
    it { should have_field(:last_sign_in_at).of_type(Time) }
    it { should have_field(:current_sign_in_ip).of_type(String) }
    it { should have_field(:last_sign_in_ip).of_type(String) }
    it { should have_field(:reset_password_token).of_type(String) }
    it { should have_field(:reset_password_sent_at).of_type(Time) }
    it { should have_field(:authentication_token).of_type(String) }
    # it { should have_field(:confirmation_token).of_type(String) }
    # it { should have_field(:confirmed_at).of_type(Time) }
    # it { should have_field(:confirmation_sent_at).of_type(Time) }
    # it { should have_field(:confirmation_redirection_url).of_type(String) }
    # it { should have_field(:unconfirmed_email).of_type(String) }

  # Custom fields
    it { should have_field(:name).of_type(String) }

  # describe "Associations" do
  # end

  describe "Validations" do
    # Devise fields
    it { should validate_presence_of(:email)                          }
    it { should validate_format_of(:email)                            }
    it { should validate_presence_of(:encrypted_password)             }
    it { should validate_presence_of(:password)                       }
    it { should validate_confirmation_of(:password)                   }
    it { should validate_length_of(:password).within(6..128)          }
  end
end
