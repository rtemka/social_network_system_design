// target_db - postgresql
// replication: master-slave
// replication factor: 3
// replication type: async

Table travel_post_ratings {
  id integer [primary key]
  author_id integer [note: 'reference to Users table in UserService']
  travel_post_id integer [note: 'reference to TravelPost in TravelPostService']
  rate integer

  indexes {
    travel_post_id [type: btree]
    author_id [type: btree]
  }
}
