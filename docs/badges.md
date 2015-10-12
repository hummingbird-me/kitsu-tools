# Achievement Badges

Hummingbird would like to be able to reward active users for using the site in a way that allows them to
show off their reputation in the community as well as the variety of anime and dramas they have watched,
manga they have read, etc.  Hummingbird's badges could be similar in style to 
[those of MALGraph](https://github.com/rr-/malgraph4/wiki/Achievements).

In this document, we describe the categories of badges available, as well as the specific badges in each
category, how they are unlocked, and what they represent.  This guide is meant to serve largely as a
developer-first specification of how badges will be implemented, but in such a way that user documentation
(in the form e.g. of a blog post) could be easily written.

## Categories

### Anime

Title | Description | How to Unlock
------|-------------|--------------
First Franchise | Completed an entire franchise | Watched every episode of anime in a franchise

### Manga

Title | Description | How to Unlock
------|-------------|--------------
Heavy Reader | Completed 25 manga | Manga count reaches 25


### Drama

Title | Description | How to Unlock
------|-------------|--------------
Dramaniac | Watched ALL the dramas | Drama count = number of dramas in DB

### Community

Title | Description | How to Unlock
------|-------------|--------------
Hatchling | Joined the Hummingbird community | Create an account
