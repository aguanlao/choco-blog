module PostHelpers
  def try_post_update(post)
    patch post_url(post), params: { 
      post: { title: "Updated title", description: "Edited description" } 
    }
    Post.find(post.id)      
  end
end