# Social Network For Travelers - System Design

Example of the homework for [course by System Design](https://balun.courses/courses/system_design).
The social network for travelers is a web service for all travel and adventure lovers, where you can share photos and impressions of visited places, as well as follow and comment on the adventures of other travelers.

### Functional requirements:

- publishing travel posts with photos, a short description and a link to a specific place of travel
- rating and comments of other travelers posts
- subscribe to other travelers to keep track of their activity
- search for popular travel destinations and view posts from these places
- viewing the feed of other travelers

### Non-functional requirements:

- **DAU**: 10 000 000
- **Availability** 99,95% (no more than 4 hours of unavailability per year)
- **Geo Usage**: only CIS countries
- **Seasonal nature**: expected x3 load on holidays such as New Year, Christmas and Victory Day, x2 load during summer
- **Activity**:
    - 30 posts per user on average monthly
    - 3 user daily sessions with 10 view post requests per session
    - 10 user ratings daily
    - 30 user comments daily
    - 5 user search requests for posts with popular travel destinations daily
    - 3 user feed request daily, 3 page requests on average
- **Limits**:
    - 20 user posts per day
    - each post has no more than 8 photos attached
    - post title is no more than 100 characters and post description is no more than 280 characters(as tweet)
    - 100 comments per post
    - comments per post page size is 10 
    - each comment is no more than 280 characters (as tweet)
    - 20 subscriptions per user
    - feed page size is 10 posts
- **Timings**:
    - publish post - 1-1.5 seconds
    - view post - 1-2 seconds
    - publish rating and comment - 1-2 seconds
    - view feed - 2 seconds
- **Data storage**: data is always kept  

## Basic calculations

### Daily active users

    DAU = 10 000 000

### Open connections

    Connections = 10_000_000 * 0.1 = 1_000_000

### posts
RPS:

    Write
    Each user publish 30 posts per month
    RPS = 10_000_000 * (30 / 30) / 86400 ~= 120

    Read
    Each user has 3 sessions with 10 view post requests per session
    RPS = 10_000_000 * 3 * 10 / 86400 ~= 3500

Traffic:
    
    Post Metadata average size is 500B
    Post Metadata Write = 120 * 500B = 60 KB/s 
    Post Metadata Read = 120 * 500B = 60 KB/s 

    Post Media average size is ~1.5MB 
    Post Media Write = 120 * 1.5MB = 180 MB/s
    Post Meida Read  = 3500 * 1.5MB = 5 GB/s

### ratings
RPS:

    Write
    Each user leaves 10 ratings daily
    RPS = 10_000_000 * 10 /  86400 ~= 1150 

    Read
    RPS = 10_000_000 * 10 /  86400 ~= 1150 

Traffic:

    Average rating size ~= 16 bytes
    Write = 1150 * 16 = 18 KB/s
    Read  = 3500 * 16 = 56 KB/s

### comments
RPS:

    Write
    Each user leaves 30 comments daily
    RPS = 10_000_000 * 30 / 86400 ~= 3500 

    Read
    RPS = 10_000_000 * 30 / 86400 ~= 3500 

Traffic:

    Average comment size ~= 120 bytes
    Write = 1150 * 120 = 138 KB/s
    Read  = 3500 * 120 * 10 = 4 MB/s

### feeds
RPS:
    
    Read
    Each user makes 3 feed requests daily(page size=10)
    RPS = 10_000_000 * 3 / 86400 ~= 347 

Traffic:

    Average feed size = post size * 10 = 15MB 
    Read  = 347 * 15MB ~= 5 GB/s

