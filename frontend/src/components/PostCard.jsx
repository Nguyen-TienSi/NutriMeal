import React, { useState } from 'react';
import { Heart, Share2, MoreVertical, Trash2 } from 'lucide-react';
import ShareMenu from './ShareMenu';

const PostCard = ({ post, onLike, onDelete, requireAuth, user }) => {
  const [isShareMenuOpen, setIsShareMenuOpen] = useState(false);
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const formattedDate = new Date(post.createdAt).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });

  const isLiked = user && post.likedBy?.includes(user._id);
  const isAuthor = user?._id === post.author._id;

  // Convert binary image data to base64 URL if needed
  const getImageUrl = () => {
    // console.log('Image data:', post.image);
    console.log('Image type:', post.imageType);
    
    if (!post.image) return null;

    // Handle MongoDB binary data structure
    if (post.image.$binary && post.image.$binary.base64) {
      return `data:${post.imageType || 'image/jpeg'};base64,${post.image.$binary.base64}`;
    }

    // Handle direct base64 string
    if (typeof post.image === 'string') {
      if (post.image.startsWith('data:')) {
        return post.image;
      }
      return `data:${post.imageType || 'image/jpeg'};base64,${post.image}`;
    }

    // Handle Buffer or array data
    if (Array.isArray(post.image) || (post.image.type === 'Buffer')) {
      try {
        const buffer = Buffer.from(post.image);
        return `data:${post.imageType || 'image/jpeg'};base64,${buffer.toString('base64')}`;
      } catch (error) {
        console.error('Error converting image buffer:', error);
        return null;
      }
    }

    console.log('Unhandled image format:', post.image);
    return null;
  };

  const imageUrl = getImageUrl();

  return (
    <div className="card bg-base-100 shadow-xl">
      <div className="card-body">
        {/* Post Header */}
        <div className="flex justify-between items-start">
          <div className="flex items-center gap-3">
            <div className="avatar">
              <div className="w-10 rounded-full">
                <img src={post.author.picture} alt={post.author.name} />
              </div>
            </div>
            <div>
              <h3 className="font-semibold">{post.author.name}</h3>
              <p className="text-sm text-base-content/70">
                {formattedDate}
              </p>
            </div>
          </div>
          <div className="relative">
            <button 
              className="btn btn-ghost btn-sm btn-circle"
              onClick={() => setIsMenuOpen(!isMenuOpen)}
            >
              <MoreVertical size={20} />
            </button>
            
            {isMenuOpen && isAuthor && (
              <div className="absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-base-100 ring-1 ring-black ring-opacity-5">
                <div className="py-1">
                  <button
                    onClick={() => {
                      onDelete(post._id);
                      setIsMenuOpen(false);
                    }}
                    className="flex w-full items-center px-4 py-2 text-sm text-error hover:bg-base-200 gap-2"
                  >
                    <Trash2 size={16} />
                    Delete Post
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Post Content */}
        <p className="mt-4 whitespace-pre-wrap">{post.content}</p>
        {imageUrl && (
          <div className="mt-4 relative">
            <img
              src={imageUrl}
              alt="Post content"
              className="rounded-lg object-cover w-full max-h-96"
              loading="lazy"
              onError={(e) => {
                console.error('Error loading image');
                e.target.style.display = 'none';
              }}
            />
          </div>
        )}

        {/* Post Actions */}
        <div className="flex items-center gap-6 mt-4">
          <button
            onClick={() => onLike(post._id)}
            disabled={requireAuth}
            className={`btn btn-ghost btn-sm gap-2 ${
              isLiked ? "text-primary" : ""
            }`}
            title={requireAuth ? "Log in to like posts" : ""}
          >
            <Heart
              size={20}
              className={isLiked ? "fill-current" : ""}
            />
            {post.likes}
          </button>
          <div className="relative">
            <button 
              className="btn btn-ghost btn-sm gap-2"
              onClick={() => setIsShareMenuOpen(!isShareMenuOpen)}
            >
              <Share2 size={20} />
            </button>
            <ShareMenu 
              postId={post._id} 
              isOpen={isShareMenuOpen}
              onClose={() => setIsShareMenuOpen(false)}
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default PostCard;