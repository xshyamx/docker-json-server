module.exports = function() {
  let data = {
		posts: [],
		comments: []
	};
	for ( let i = 1; i <= 3; i++ ) {
		data.posts.push({ id: i, title: 'This is post #' + i });
		for ( let cid = 1; cid <= i; cid++ ) {
			data.comments.push({ id: cid, body: 'Comment #' + cid, postId: i })
		}
	}
	data.profile = { "name": "typicode" }
  return data;
}
