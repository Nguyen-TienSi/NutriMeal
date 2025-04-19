import React from 'react';
import { Image as ImageIcon, Send, Loader2 } from 'lucide-react';

const CreatePost = ({ 
  user, 
  newPost, 
  setNewPost, 
  image, 
  setImage, 
  isLoading, 
  onSubmit 
}) => {

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      if (file.size > 5 * 1024 * 1024) {
        alert("Image too large (max 5MB)");
        return;
      }
      if (!file.type.startsWith('image/')) {
        alert("Please select an image file");
        return;
      }
      setImage(file);
    }
  };

  return (
    <div className="card bg-base-100 shadow-xl mb-8">
      <div className="card-body">
        <form onSubmit={onSubmit}>
          <div className="flex items-start gap-4">
            <div className="avatar">
              <div className="w-10 rounded-full">
                <img src={user?.picture} alt="profile" />
              </div>
            </div>
            <div className="flex-1">
              <textarea
                value={newPost}
                onChange={(e) => setNewPost(e.target.value)}
                placeholder="Share your thoughts..."
                className="textarea textarea-bordered w-full min-h-[100px]"
              />
              {image && (
                <div className="mt-2 relative">
                  <img
                    src={URL.createObjectURL(image)}
                    alt="Preview"
                    className="max-h-40 rounded-lg"
                  />
                  <button
                    onClick={() => setImage(null)}
                    className="btn btn-circle btn-sm absolute top-2 right-2"
                  >
                    ×
                  </button>
                </div>
              )}
              <div className="flex justify-between items-center mt-4">
                <label className="btn btn-ghost btn-sm">
                  <ImageIcon size={20} />
                  <input
                    type="file"
                    accept="image/*"
                    className="hidden"
                    onChange={handleImageChange}
                  />
                </label>
                <button
                  type="submit"
                  disabled={isLoading || (!newPost.trim() && !image)}
                  className="btn btn-primary btn-sm"
                >
                  {isLoading ? (
                    <Loader2 className="animate-spin" size={20} />
                  ) : (
                    <>
                      <Send size={20} />
                      Post
                    </>
                  )}
                </button>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};

export default CreatePost;