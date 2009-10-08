class CommentCell < Cell::Base
  helper :all

  def controls
    @post = @opts[:post]
    render
  end
  
  def headline
    @post = @opts[:post]
    render
  end
end
