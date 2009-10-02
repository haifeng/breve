module PathHelper
  def path_for_model(post)
    send("#{post.class.name.downcase}_path", post)
  end

  def edit_path_for(post)
    send("edit_#{post.class.name.downcase}_path", post)
  end
  
  def vote_path_for(post)
    send("vote_#{post.class.name.downcase}_path", post)
  end

  def comments_path_for(post)
    send("#{post.class.name.downcase}_comments_path", post)
  end

  def reply_to_comment_for_topic_path_for(post)
    send("reply_#{post.topic.class.name.downcase}_comment_path", 
      post.commentable, post)
  end
end
