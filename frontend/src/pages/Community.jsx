import React, { useState, useEffect } from "react";
import { useUser } from "../contexts/UserContext";
import { generateDummyPosts } from "../utils/dummyData";
import { Loader2 } from "lucide-react";
import PostCard from "../components/PostCard";
import CreatePost from "../components/CreatePost";

const Community = () => {
  const [posts, setPosts] = useState([]);
  const [newPost, setNewPost] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const [image, setImage] = useState(null);
//   const [page, setPage] = useState(0);
  const { user } = useUser();

  const handleCreatePost = async (e) => {
    e.preventDefault();
    if (!newPost.trim() && !image) return;

    setIsLoading(true);
    try {
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      const newDummyPost = {
        _id: `post-${Date.now()}`,
        content: newPost,
        image: image ? URL.createObjectURL(image) : null,
        createdAt: new Date().toISOString(),
        likes: 0,
        isLiked: false,
        author: {
          _id: user._id,
          name: user.name,
          picture: user.picture,
        }
      };

      setPosts(prev => [newDummyPost, ...prev]);
      setNewPost("");
      setImage(null);
    } catch (error) {
      console.error("Failed to create post:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleLike = async (postId) => {
    setPosts(prev => prev.map(post => {
      if (post._id === postId) {
        return {
          ...post,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
          isLiked: !post.isLiked
        };
      }
      return post;
    }));
  };

  const loadMorePosts = async () => {
    setIsLoadingMore(true);
    try {
      await new Promise(resolve => setTimeout(resolve, 1000));
      const newPosts = generateDummyPosts(posts.length);
      setPosts(prev => [...prev, ...newPosts]);
      setPage(prev => prev + 1);
    } catch (error) {
      console.error("Failed to load more posts:", error);
    } finally {
      setIsLoadingMore(false);
    }
  };

  useEffect(() => {
    const initialPosts = generateDummyPosts(0);
    setPosts(initialPosts);
  }, []);

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-2xl mx-auto">
        <h1 className="text-3xl font-bold mb-8">Community</h1>

        <CreatePost
          user={user}
          newPost={newPost}
          setNewPost={setNewPost}
          image={image}
          setImage={setImage}
          isLoading={isLoading}
          onSubmit={handleCreatePost}
        />

        <div className="space-y-6">
          {posts.map((post) => (
            <PostCard 
              key={post._id} 
              post={post} 
              onLike={handleLike}
            />
          ))}

          <div className="text-center mt-8">
            <button
              onClick={loadMorePosts}
              disabled={isLoadingMore}
              className="btn btn-primary btn-wide"
            >
              {isLoadingMore ? (
                <>
                  <Loader2 className="animate-spin" size={20} />
                  Loading...
                </>
              ) : (
                "Read More"
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Community;