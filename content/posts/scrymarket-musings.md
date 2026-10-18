---
title: "The Making of Scrymarket: musing on vibe coding an app"
slug : "the-scrymarket-experiment"
draft: false
featuredImg: ""
description : "Thoughts and feelings about making a vibe coded application."
date: 2026-10-18
tags: 
    - project
scrolltotop : true
toc : false
mathjax : false
---

# Making of Scrymarket: musing on vibe coding an app

## The Idea

I wanted to see what vibe coding could do and needed a personal project to work on.

The idea was bequeathed upon me by pure frustration and 35 browser tabs. I was trying to save money by comparing the prices of Magic the Gathering cards across 10 local game stores, 3 eBay listings and FB market place. Running the calculus on the cost of the card along with how many times I was gonna get slugged with postage. There was the idea; I'm going to scrape as many local games stores in Australia for Magic the Gathering singles, slam 'em into a database and host a website so anyone can find cheap cards.

## Making a plan

I started knowing I wanted to, eventually, use AWS for hosting the infra so I could cut some terraform. A simple web app using simple services; RDS on the backend and ECS for the frontend and scraper. The problem with starting there is that shit is expensive. So with an endstate in mind I went about designing the services to be hosted in Docker for ease of testing, hosting and migrating. Conveniently, I already have a server and have experience exposing services to the internet. Time to spin up some containers, put a Cloudflare tunnel in front and we have a (reasonably) secure place in which to host my app. (I did a whole network uplift so I had isolated VLAN for this app as well as putting in some other infra security improvements but that's a whole other post).

Even though it's a solo project GitOps was also important from the planning phase. Having a protected main branch, running PRs, automated linting, testing and docker builds all planned from the beginning but held off until phase 2 at least. In the beginning running docker locally and then including the dockerfiles in the repo pulling the repo down to the prod server and running the commands manually would be...acceptable.

Most unimportantly (to me anyways) the front end service and the scrapers. Since I am not really a dev and this is where the vibes would be doing the heavy lifting, I wanted nothing revolutionary. I went with TS everywhere, I prefer a strongly typed language shoot me. Next.js as the framework for the web code. All this on top of the true hero, everyone's favourite database; postgres.

Now I had the tools laid out it was time to turn this skeleton into a fully formed application.

## Musings on the process

Initially I just one shot it, fed in one single prompt with my outline for the tech stack and what I wanted it to perform. Claude returned me a working project. I hated it. I had a folder structure, files and code that was completely opaque. It was too quick and too easy and worst of all unverifiable. I deleted the entire thing.

I went with a more traditional approach next. Exactly how I'd approach a project without the magic machine; build one feature at a time, test it and validate the output. Rinse, repeat and refactor. This was a more sustainable method for me to produce something I had a modicum of understanding about. I got a feeling for the structure, the cost and caveats and still had better comprehension of the code base.

I worked through small features until I was happy with what I was seeing on localhost and then set about creating the first pass production version of Scrymarket. I spun up some containers and started running my apps. It was just four stores being scraped in the beginning but I had a publicly accessible site that I could show off.

Slowly over time I added more stores to be scraped, improved, added and subsequently removed features, solved bugs, created bugs, took feedback from users and I've even merged a few PRs raised by another contributor (that was cool).

The prolific nature of AI code also leads ideas to proliferate into actual features faster than they make sense to implement. I created on a whim and added bulk and complexity to the app without much consideration other than “that’s a neat idea”'. I've just been through a process of cutting what didn't serve the core purpose of Scrymarket, for the better.

I've come to liken working on Scrymarket to working with a legacy code base more than something I've crafted. It's esoteric in its creation but I comprehend enough to solve problems. I find it useful as I am more confident in my ability to just start digging into codebases, changing things and testing.

The biggest revelation I've made is my need for perfect solutions and perfect code has drastically reduced. Every solution has a trade off and some solutions are actually too much for right now. While I've always theoretically known this it helps to have had to make those decisions and live in their consequences rather than just complaining "Why wouldn't you just do it better?!".

## Learnings 6 months on

My big takeaway was to narrow the LLMs range into small chunks. It allowed for smaller windows and less hallucinations. I also adopted the practice of properly creating feature branches and running my own pull request even as a solo developer (usually I'll have much longer lived branches for personal work). I've become the reviewer and no longer the writer. I'm aware that reviewing is a different skill to writing it and I need to be conscious of skill atrophy when it comes to writing actual code.

I've heard the notion that the art of programming is being lost and as someone that has been coding for over 15 years at this point (but never seen myself as a "developer") I find I was not so concerned with the artfulness. While I do appreciate nice code and love the satisfaction of solving tricky puzzles or getting in the zone and just creating in a fugue state. I think I prefer the output over the process. The appeal in development for me is found in the automating, process simplification and the practical usefulness of a tool.

So much of my original plan for Scrymarket didn't eventuate as planned, here's how Scrymarket looks now:

- I am still hosting the whole application on my server. I didn’t see that happening. The cost vs reward just isn't there yet, I get ~60 unique visits a day but I still have plenty of compute headroom and $0 ongoing costs.
    
- Monitoring was added too with a full locally hosted stack of Loki, Promethus, Grafana and Umami. This is probably one of the most unexpected wins I didn't plan for and I really enjoyed crafting monitoring, alerts and reports.
    
- GitHub actions builds the containers and drops them in GCR and they get deployed by running a script on the host. Eventually I'll make the deployment fully automatic but for now sshing in and running one command is easy enough.
    
- Users can generate issues and feedback automatically via a form that maps to GitHub issues.  I’m really happy with keeping the tool chain down to a minimum and not having a CRM style tool to manage as well.
    
- I made a really dumb method for free emails from my domain without having to pay or host an outbound mail server, you can read about it here.
    
- I added affiliate links for eBay, because it is easy to apply for and I wondered if it would produce the funding needed to migrate to a cloud hosted solution. The jury is still out on this one.
    

## Closing thoughts

Vibe coding an app is totally doable. I can see why people get sucked in. I am under no illusion, the code quality for Scrymarket is not good, I would not sell this to anyone and if I wasn't careful and somewhat informed on development I'd have made a much worse, much less maintainable project.

I didn't learn much TypeScript as I initially planned but I learnt more about the things I was already comfortable with: All the infra stuff is solid AF. I should have seen that coming. I was surprised and have come to build an appreciation for the full suit of tooling that I only get a chance to lightly touch in my day job. I also really valued the experience of starting from scratch, making real impactful decisions on best in class vs best for right now.

I have a working project that people use and I can slowly chip away at and learn more. Going forward I want to treat this more as a proper product and see what I can do to make it a viable and robust tool.