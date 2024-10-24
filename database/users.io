// target_db - postgresql
// replication: master-slave
// replication factor: 3
// replication type: async

Table users {
  id integer [primary key]
  email varchar

  indexes {
    email [type: btree]
  }
}

table subscriptions {
  author_id integer [ref: > users.id]
  subscriber_id integer [ref: > users.id]

  indexes {
    (author_id, subscriber_id) [pk]
  }
}

