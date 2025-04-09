export const generateDummyPosts = (start = 0, limit = 10) => {
  const posts = [];
  for (let i = start; i < start + limit; i++) {
    posts.push({
      _id: `post-${i}`,
      content: `This is a sample post #${i} about nutrition and healthy eating. Here's some tips and thoughts about maintaining a healthy lifestyle! 🥗`,
      image: i % 3 === 0 ? `../public/${1}.jpg` : null,
      createdAt: new Date(Date.now() - i * 3600000).toISOString(),
      likes: Math.floor(Math.random() * 50),
      isLiked: Math.random() > 0.5,
      author: {
        _id: `user-${i % 5}`,
        name: `User ${i % 5}`,
        picture: `https://i.pravatar.cc/150?img=${i % 5}`,
      }
    });
  }
  return posts;
};