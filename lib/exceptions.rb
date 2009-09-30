class PostException < Exception
  attr_reader :post

  def initialize(post)
    @post = post
  end
end

class DuplicatePostException < PostException; end
