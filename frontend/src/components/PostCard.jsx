import React from 'react';
import { Heart, Share2, MoreVertical } from 'lucide-react';

const PostCard = ({ post, onLike }) => {
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
                {new Date(post.createdAt).toLocaleDateString()}
              </p>
            </div>
          </div>
          <button className="btn btn-ghost btn-sm btn-circle">
            <MoreVertical size={20} />
          </button>
        </div>

        {/* Post Content */}
        <p className="mt-4">{post.content}</p>
        {post.image && (
          <img
            src={post.image}
            alt="Post"
            className="rounded-lg mt-4 max-h-96 object-cover w-full"
          />
        )}

        {/* Post Actions */}
        <div className="flex items-center gap-6 mt-4">
          <button
            onClick={() => onLike(post._id)}
            className={`btn btn-ghost btn-sm gap-2 ${
              post.isLiked ? "text-red-500" : ""
            }`}
          >
            <Heart
              size={20}
              className={post.isLiked ? "fill-current" : ""}
            />
            {post.likes}
          </button>
          <button className="btn btn-ghost btn-sm gap-2">
            <Share2 size={20} />
          </button>
        </div>
      </div>
    </div>
  );
};

export default PostCard;