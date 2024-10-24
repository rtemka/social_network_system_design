// target_db - postgresql
// replication: master-slave
// replication factor: 3
// replication type: async

Table travel_posts {
  id integer [primary key]
  author_id integer [note: 'reference to User entity in UserService']
  title varchar
  description varchar
  geog_point geography [note: 'contains latitude and longitude']

  indexes {
    geog_point [type: gist, note: 'https://postgis.net/workshops/postgis-intro/indexing.html']
    author_id [type: btree]
  }
}

table geo {
  name varchar [note: 'human readable name of the location']
  name_lexemes tsvector [note: 'postgres tsvector type for full-text search or analogous']
  geo geography [note: 'geography spatial type, typically a multipolygon']

  indexes {
    name_lexemes [type: gin, note: 'https://www.postgresql.org/docs/current/gin.html#GIN']
  }

}

