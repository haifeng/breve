class PostCell < Cell::Base
  helper :all

  def controls
    @post = @opts[:post]
    render
  end
  
  def headline
    @post = @opts[:post]
    render
  end

  def info
    @post = @opts[:post]
    render
  end
  
  def vote
    @post = @opts[:post]
    render
  end
end
