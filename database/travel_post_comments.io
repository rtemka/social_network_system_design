// target_db - postgresql
// replication: master-slave
// replication factor: 3
// replication type: async

Table travel_post_comments {
  id integer [primary key]
  author_id integer [note: 'reference to User entity in UserService']
  travel_post_id integer [note: 'reference to TravelPost entity in TravelPostService']
  reply_id integer [ref: - travel_post_comments.id]
  txt text

  indexes {
    travel_post_id [type: btree]
    author_id [type: btree]
  }
}
