require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Vote do
  before(:each) do
    @valid_attributes = {
      :user     => mock_model(User),
      :voteable => mock_model(Post)
    }
  end

  it "should create a new instance given valid attributes" do
    Vote.create!(@valid_attributes)
  end
end
