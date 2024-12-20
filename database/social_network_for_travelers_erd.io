// This is logical scheme
// of SocialNetworkForTravelers App
// with microservice architecture.
// Since it is microservice architecture
// presented tables are separated into their own
// services databases.

Table travel_posts {
  Note {
    'TravelPost Service Database'
  }

  id integer [primary key]
  author_id integer [ref: > users.id]
  title varchar
  description varchar
  geog_point geography [note: 'contains latitude and longitude']

  indexes {
    geog_point [type: gist, note: 'https://postgis.net/workshops/postgis-intro/indexing.html']
    author_id [type: btree]
  }
}

Table users {
  Note {
    'User Service Database'
  }

  id integer [primary key]
  email varchar

  indexes {
    email [type: btree]
  }
}

Table comments {
  Note {
    'Comment Service Database'
  }

  id integer [primary key]
  author_id integer [ref: > users.id]
  travel_post_id integer [ref: > travel_posts.id]
  reply_id integer [ref: - comments.id]
  txt text

  indexes {
    travel_post_id [type: btree]
    author_id [type: btree]
  }
}

Table ratings {
  Note {
    'Rating Service Database'
  }

  id integer [primary key]
  author_id integer [ref: >  users.id]
  travel_post_id integer [ref: > travel_posts.id]
  rate integer

  indexes {
    travel_post_id [type: btree]
    author_id [type: btree]
  }
}

table photos {
  Note {
    'Media Service Database'
  }

  id integer [primary key]
  travel_post_id integer [ref: > travel_posts.id]
  uri varchar [note: 'link to photo blob in object storage']

  indexes {
    travel_post_id [type: btree]
  }
}

table subscriptions {
  Note {
    'User Service Database'
  }

  author_id integer [ref: > users.id]
  subscriber_id integer [ref: > users.id]

  indexes {
    (author_id, subscriber_id) [pk]
  }
}

table geo {
  Note {
    'TravelPost Service Database. Reference table with geo spatial data, downloaded from external source'
  }

  name varchar [note: 'human readable name of the location']
  name_lexemes tsvector [note: 'postgres tsvector type for full-text search or analogous']
  geo geography [note: 'geography spatial type, typically a multipolygon']

  indexes {
    name_lexemes [type: gin, note: 'https://www.postgresql.org/docs/current/gin.html#GIN']
  }

}

