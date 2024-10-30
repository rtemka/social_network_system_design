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

## Design overview

For system design I have used [C4 model](https://c4model.com/).

<p align="center">
    </br><b>Level 1.</b> System context diagram</br></br>
</p>

<p align="center">
  <img src="architecture/context.drawio.svg" />
</p>

<p align="center">
    </br><b>Level 2.</b> Container diagram</br></br>
</p>

<p align="center">
  <img src="architecture/container.drawio.svg" />
</p>

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
    Post Metadata Read = 3500 * 500B = 1.8 MB/s 

    Post Media average size is ~1.5MB 
    Post Media Write = 120 * 1.5MB = 180 MB/s
    Post Meida Read  = 3500 * 1.5MB = 5 GB/s

### ratings
RPS:

    Write
    Each user leaves 10 ratings daily
    RPS = 10_000_000 * 10 /  86400 ~= 1150 

    Read
    Each user makes 30 reads by batch of 100 ratings
    RPS = 10_000_000 * 30 / 86400 ~= 3500 

Traffic:

    Average rating size ~= 32 bytes
    Write = 1150 * 32 = 34 KB/s
    Read  = 3500 * 32 = 112 KB/s

### comments
RPS:

    Write
    Each user leaves 30 comments daily
    RPS = 10_000_000 * 30 / 86400 ~= 3500 

    Read
    RPS = 10_000_000 * 30 / 86400 ~= 3500 

Traffic:

    Average comment size ~= 120 bytes
    Write = 3500 * 120 = 4 MB/s
    Read  = 3500 * 120 * 10 = 4 MB/s

### feeds
RPS:
    
    Read
    Each user makes 3 feed requests daily(page size=10)
    RPS = 10_000_000 * 3 / 86400 ~= 347 

Traffic:

    Average feed size = post size * 10 = 15MB 
    Read  = 347 * 15MB ~= 5 GB/s

## Disks Usage (for 1 year)

### posts disk usage

    Posts Media:
    Traffic = 180 MB/s + 5 GB/s ~= 5.2 GB/s
    IOPS = 3620

    Disks Type = SSD(SATA) (Capacity ~= 100TB, IOPS ~= 1000, Throughput ~= 500 MB/s)
    Capacity per year = 86400 * 365 * 180 MB = 5.1 PB
    Disks_for_capacity = 5.1 PB / 100 TB = 51 DISKS
    Disks_for_throughput = 5 GB/s / 500 MB/s = 10 DISKS
    Disks_for_iops = 3620 / 1000 = 4 DISKS

    Disks = max(51, 10, 4) = 51 DISKS

    Posts Metadata:
    Traffic = 60 KB/s + 1.8 MB/s = 1.8 MB/s
    IOPS = 3620

    Disks Type = SSD(SATA) (Capacity ~= 100TB, IOPS ~= 1000, Throughput ~= 500 MB/s)
    Capacity per year = 86400 * 365 * 1.8 MB = 56 TB
    Disks_for_capacity = 56 TB / 100 TB = 1 DISKS
    Disks_for_throughput = 1.8 MB/s / 500 MB/s = 1 DISKS
    Disks_for_iops = 3620 / 1000 = 4 DISKS

    Disks = max(1, 1, 4) = 4 DISKS

### posts feed RAM usage

    Each user has max 20 subscriptions * 2 (home_feed and subscription feed).
    RAM Type = RAM DDR4 (Capacity = 64GB)
    Capacity = 10000000 * 20 * 500B(Posts metadata) * 2 = 200 GB
    Total = 5 RAM units 

### comments disk usage

    Traffic = 4 MB/s + 4 MB/s ~= 8 MB/s
    IOPS = 7000

    Disks Type = SSD(SATA) (Capacity ~= 100TB, IOPS ~= 1000, Throughput ~= 500 MB/s)
    Capacity per year = 86400 * 365 * 4 MB = 126 TB
    Disks_for_capacity = 126 TB / 100 TB = 2 DISKS
    Disks_for_throughput = 4 MB/s / 500 MB/s = 1 DISKS
    Disks_for_iops = 7000 / 1000 = 7 DISKS

    Disks = max(2, 1, 7) = 7 DISKS

### ratings disk usage

    Traffic = 34 KB/s + 112 KB/s ~= 150 KB/s
    IOPS = 4650

    Disks Type = SSD(SATA) (Capacity ~= 100TB, IOPS ~= 1000, Throughput ~= 500 MB/s)
    Capacity per year = 86400 * 365 * 34 KB  = 1.1 TB
    Disks_for_capacity = 1.1 TB / 100 TB = 1 DISKS
    Disks_for_throughput = 34 KB/s / 500 MB/s = 1 DISKS
    Disks_for_iops = 4650 / 1000 = 5 DISKS

    Disks = max(1, 1, 5) = 5 DISKS

### total disk usage

    WriteTraffic = Posts(180 MB/s) + Ratings(34 KB/s) + Comments(4 MB/s) ~= 185 MB/s
    ReadTraffic = Posts(5 GB/s) + Ratings(112 KB/s) + Comments(4 MB/s) + Feed(5 GB/s) ~= 10 GB/s
    Traffic = WriteTraffic + ReadTraffic ~= 11 GB/s
    IOPS = 3620 + 4650 + 7000 + 347 = 15617

    Disks Type = SSD(SATA) (Capacity ~= 100TB, IOPS ~= 1000, Throughput ~= 500 MB/s)
    Capacity per year = 86400 * 365 * 185 = 5.8 PB
    Disks_for_capacity = 5.8 PB / 100 TB = 58 DISKS
    Disks_for_throughput = 11 GB/s / 500 MB/s = 22 DISKS
    Disks_for_iops = 15617 / 1000 = 16 DISKS

    Disks = max(58, 22, 16) = 58 DISKS

## Hosts

### Travel Posts Service

    Replication_factor = 3; Disks = 4
    Hosts = 4 / 2 = 2 
    Hosts_with_replication = 2 * 3 = 6 

### Media Service 

    Replication_factor = 2;
    RAID 50 for storage
    Each RAID consists of 10 disks by 22TB = 220TB  
    Hosts = 51 / 10 = 5 
    Hosts_with_replication = 2 * 5 = 10 

### Posts Feed Service 

    Replication_factor = 3; 4 DDR4(64GB)
    Hosts = 4 / 4 = 1 
    Hosts_with_replication = 3 * 1 = 3 
    
### Comments Service

    Replication_factor = 3; Disks = 7 
    Hosts = 7 / 2 = 4 
    Hosts_with_replication = 3 * 4 = 12 

### Ratings Service

    Replication_factor = 3; Disks = 5
    Hosts = 5 / 2 = 3 
    Hosts_with_replication = 3 * 3 = 9 

