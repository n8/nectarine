# Nectarine 

*Parallel processing*

> a mode of computer operation in which a process is split into parts that execute simultaneously on different processors attached to the same computer.

I find myself constantly working on apps that need a mechanism to split an array of objects into multiple threads or CPUs to perform things on those objects, then return processing back to the main thread. 

But it's still something I find surprisingly difficult to do in Ruby/Rails. There's definitely libraries that successfully help, but they all suffer from problems around versions of Ruby being used (green threads, native threads, interpreter locks) or your OS/environment (Windows/Mac/Linux).

It dawned on me though that we already have a really interesting place to do parallel processing and communication amongst multiple threads/CPUs that's fairly agnostic of environment AND has built in fault tolerance: our current Job queue. 

Whether we're using Resque/Sidekiq/Delayed Job/etc. Why not send things there for parallel processing our main thread waits for execution? 

So here's a proof of concept to do just that. It's called Nectarine. 

Nectarine (like peach - parallel each) works over a collection of Active Record objects, sending each object to your Job system using Active Job, and executing a single method on that object. The main thread blocks until processing has completed on all the objects. 

That's it. I'm using it now in an app ([FilmHope.com](https://filmhope.com/)) that takes a user's video, converts it into hundreds of static thumbnails, and then for each thumbnail, Nectarine jobs out processing on each image, calling a bunch of other APIs as needed. It's a super slow task, which is why having Nectarine handle those hundreds of thumbs in parallel is a nice workflow to have. 


## Usage
Once nectarine is installed, you can call it on your collections of Active Record objects.  

Let's say a Snail model in our system has a super slow method like "start_racing". It's slow because start_racing calls external APIs, does a bunch of other magic, whatever. It's slow. 

```ruby
Snail.all.each(&:start_racing) 
Rails.logger.debug("That took forever")
```

Would take forever. 

Instead:  

```ruby
Snail.all.nectarine(:start_racing) 
Rails.logger.debug("That took a lot less than forever")
```

That's it. In this example, the Rails.logger.debug line isn't executed until all the snails in Snail.all have executed their "start_racing" method. 

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'nectarine'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install nectarine
```

## What's next. 

There's a lot of gaps in this library right now. 

A total Timeout period is currently hard coded at 15 minutes. That should at a very minium be configurable. There's other things like status checks of the jobs that just happen every 2 seconds. 

```ruby
Timeout::timeout(15 * 60) do 
    while(!all_job_statuses_complete?(all_jobs)) do 
        sleep 2
    end
end
```

It might be smarter to do some exponential backoff checking for their completion. There's also not very good error control or handling. 

This also just uses whatever your default queue is, which is something that should probably be configurable. 

So all feedback and pull requests are more than welcome!


## P.S. 

If you need a some help building a software project, [**whether it's advice or just extra hands, please shout**](https://www.rockstarcoders.com/contact-us/). We've got a great crew at Rockstar Coders and we'd love to help. 
