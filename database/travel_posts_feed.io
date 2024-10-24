// target_db - redis in memory
// replication factor: 3
// replication type: async

table user_feed {
  user_id integer [note: 'redis key; reference to User entity in UserService']
  travel_posts Object[] [note: 'redis value; array of travel post metadata']
}

table home_feed {
  user_id integer [note: 'redis key; reference to User entity in UserService']
  travel_posts Object[] [note: 'redis value; array of travel post metadata']
}
