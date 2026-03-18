---
title: "Cloudflare zero trust gotcha's"
slug : "zero-trust-issues"
draft: false
featuredImg: ""
description : 'Issues and solutions for setting up zero-trust policies for self host applications.'
date: 2026-03-12
tags: 
    - project
scrolltotop : true
toc : false
mathjax : false
---
### Cloudflare Zero Trust — Gating a Dev Site with Email Approval

I have been using Cloudflare tunnels for a little while now to connect back to my homelab from anywhere.  It's ver convient, if I have internet I can connect back and I've add a zero trust policy that restricts it down to just me with enforced MFA.  
I wanted to extend this access to an app, i'd been fiddling about with so I could grant one time, short lived access to the development site, that was hosted on my homelab. I also wanted to make this access easier for my by using the same pattern of email based allow policy for myself (or another friend that might want continued access).  I was being overly caustious as I had not put much effort into harding my internal server infra as nothing was open to internet (something that has very much changed now).  
I ran into some quirks and gotcha's when when trying to configure the access policies, hopefully this can bring some illumincation to other that get stuck as I did.

1. **The goal** — Lock a dev site so anyone can request access, but only I can approve it. 
I get straight through with no friction.

2. **The setup**
   - Enable One-time PIN as an identity provider
   - Create the Access application for your dev site
   - App Launcher policy: Allow your email only (required so Cloudflare recognises you as a valid approver)
   - Policy 1 (precedence 1): Allow your email — permanent, no approval
   - Policy 2 (precedence 2): Allow login methods (OTP) — everyone else, with temporary authentication and purpose justification enabled, approver set to your email

3. **The gotchas** (the good stuff)
   - Gmail `+` aliases don't work — Cloudflare treats them as the same identity
   - You can't approve your own request — approver and requester must be distinct identities
   - The App Launcher policy is mandatory — without it you get a "not allowed to approve" error even with different accounts
   - The login methods include rule is the non-obvious missing piece — without it visitors get rejected before they can even submit a request

4. **The working flow**
   - Visitor enters email → OTP → submits justification → you get approval email → click approve → they're in for that session