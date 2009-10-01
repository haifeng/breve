require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  before(:each) do
    @valid_attributes = {
      :text        => 'Lorem ipsum dolor...',
      :commentable => mock_model(Post),
      :author      => mock_model(User)
    }
  end

  it "should create a new instance given valid attributes" do
    Comment.create!(@valid_attributes)
  end
end
