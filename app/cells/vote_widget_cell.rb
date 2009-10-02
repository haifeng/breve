class VoteWidgetCell < Cell::Base
  helper :all
  
  def show
    @post = @opts[:post]
    render
  end
end
