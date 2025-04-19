import React, { useState, useEffect } from "react";
import { useUser } from "../contexts/UserContext";
import { Loader2, LogIn } from "lucide-react";
import { Link } from "react-router-dom";
import PostCard from "../components/PostCard";
import CreatePost from "../components/CreatePost";
import { apiRequest } from "../utils/api";

const Community = () => {
  const [posts, setPosts] = useState([]);
  const [newPost, setNewPost] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [isLoadingMore, setIsLoadingMore] = useState(false);
  const [image, setImage] = useState(null);
  const [page, setPage] = useState(0);
  const [error, setError] = useState(null);
  const { user } = useUser();

  // Helper function to format post data
  const formatPost = (post) => ({
    _id: post._id.$oid || post._id,
    content: post.content,
    image: post.image,
    imageType: post.imageType,
    createdAt: new Date(post.createdAt.$date?.$numberLong || post.createdAt).toISOString(),
    likes: parseInt(post.likes?.$numberInt || post.likes || 0),
    likedBy: post.likedBy || [],
    author: post.author
  });

  // Fetch initial posts
  useEffect(() => {
    const fetchPosts = async () => {
      try {
        const data = await apiRequest(`/community/posts?page=0&limit=10`);
        const formattedPosts = data.map(formatPost);
        setPosts(formattedPosts);
      } catch (err) {
        setError("Failed to load posts");
        console.error("Error fetching posts:", err);
      }
    };
    fetchPosts();
  }, []);

  const handleCreatePost = async (e) => {
    e.preventDefault();
    const content = newPost.trim();
    
    if (!content) {
      setError("Content is required");
      return;
    }
  
    setIsLoading(true);
    try {
      const formData = new FormData();
      formData.append("content", content);
      
      if (image) {
        // Validate file size and type
        if (image.size > 5 * 1024 * 1024) {
          setError("Image too large (max 5MB)");
          return;
        }
        if (!image.type.startsWith('image/')) {
          setError("Invalid file type. Please upload an image.");
          return;
        }
        formData.append("image", image, image.name);
      }
  
      // Add author data as individual fields
      formData.append("author.id", user._id);
      formData.append("author.name", user.name);
      formData.append("author.picture", user.picture || "/default-avatar.png");
  
      const createdPost = await apiRequest("/community/posts", "POST", formData, true);
      
      // Format the new post
      const formattedPost = formatPost(createdPost);
      setPosts(prev => [formattedPost, ...prev]);
      setNewPost("");
      setImage(null);
      setError(null);
    } catch (error) {
      console.error("Failed to create post:", error);
      setError(error.message || "Failed to create post. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  const handleLike = async (postId) => {
    if (!user) return; // Prevent liking if not logged in

    try {
      // Call the like API endpoint with user ID
      const response = await apiRequest(`/community/posts/${postId}/like`, "POST", {
        userId: user._id
      });

      // Update posts state optimistically
      setPosts(prev => prev.map(post => {
        if (post._id === postId) {
          const newLikedBy = response.liked 
            ? [...post.likedBy, user._id]
            : post.likedBy.filter(id => id !== user._id);

          return {
            ...post,
            likes: response.liked ? post.likes + 1 : post.likes - 1,
            likedBy: newLikedBy
          };
        }
        return post;
      }));
    } catch (error) {
      console.error("Failed to update like:", error);
      setError("Failed to update like. Please try again.");
    }
  };

  const loadMorePosts = async () => {
    setIsLoadingMore(true);
    try {
      const nextPage = page + 1;
      const data = await apiRequest(`/community/posts?page=${nextPage}&limit=10`);
      const formattedPosts = data.map(formatPost);
      setPosts(prev => [...prev, ...formattedPosts]);
      setPage(nextPage);
    } catch (error) {
      console.error("Failed to load more posts:", error);
      setError("Failed to load more posts");
    } finally {
      setIsLoadingMore(false);
    }
  };

  return (
    <div className="min-h-screen p-10">
      <div className="max-w-2xl mx-auto">
        <h1 className="text-3xl font-bold mb-8">Community</h1>

        {error && (
          <div className="alert alert-error mb-4">
            <span>{error}</span>
          </div>
        )}

        {user ? (
          <CreatePost
            user={user}
            newPost={newPost}
            setNewPost={setNewPost}
            image={image}
            setImage={setImage}
            isLoading={isLoading}
            onSubmit={handleCreatePost}
          />
        ) : (
          <div className="card bg-base-100 shadow-xl mb-8">
            <div className="card-body items-center text-center">
              <LogIn className="w-12 h-12 text-primary mb-2" />
              <h3 className="card-title">Join the Community</h3>
              <p className="text-base-content/70 mb-4">
                Sign in to share your thoughts and interact with other members
              </p>
              <Link to="/auth" className="btn btn-primary">
                Log In to Post
              </Link>
            </div>
          </div>
        )}

        <div className="space-y-6">
          {posts.map((post) => (
            <PostCard 
              key={post._id} 
              post={post} 
              onLike={handleLike}
              requireAuth={!user}
              user={user}
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