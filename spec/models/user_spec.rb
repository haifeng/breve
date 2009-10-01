require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :firstname => 'jane',
      :lastname  => 'doe',
      :password  => 'password',
      :email     => 'jane.doe@example.org'
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it { should have_many(:posts) }
  it { should have_many(:comments) }
  it { should have_many(:votes) }

  #it { should validate_uniqueness_of(:alias).case_insensitive }
  #it { should validate_uniqueness_of(:email).case_insensitive }
  #it { should validate_presence_of(:email) }
  #it { should validate_presence_of(:password) }
  #it { should validate_presence_of(:firstname) }
  #it { should validate_presence_of(:lastname) }
  
  it { should allow_value('jane.doe@example.org').for(:email) }
  it { should_not allow_value('jane.doe').for(:email) }
end
