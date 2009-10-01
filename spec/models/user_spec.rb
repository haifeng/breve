require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :email     => 'jane.doe@example.org',
      :password  => 'password',
      :firstname => 'jane',
      :lastname  => 'doe'
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
