class MainController < ApplicationController
  def view
    path = File.join('public', 'docs', "#{params[:name]}.rdoc")
    if File.exists? path
      @content = RDiscount.new(File.read path).to_html
    else
      redirect_to request.referer 
    end
  end
end
