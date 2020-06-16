module PostHelpers
  def try_post_update(post)
    post_id = post.id
    patch post_url(post), params: { 
      post: { title: "Updated title", description: "Edited description" } 
    }
    Post.find(post_id)      
  end
end