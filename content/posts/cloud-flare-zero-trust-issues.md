---
title: "Cloudflare zero trust gotchas"
slug : "zero-trust-issues"
draft: false
featuredImg: ""
description : 'Issues and solutions for setting up zero-trust policies for self-hosted applications.'
date: 2026-03-12
tags: 
    - project
scrolltotop : true
toc : false
mathjax : false
---
## Cloudflare Zero Trust — Gating a Dev Site with Email Approval

I have been using Cloudflare tunnels for a little while now to connect back to my homelab from anywhere.  It's very convenient, if I have internet I can connect back and I've added a zero trust policy that restricts it down to just me with enforced MFA.
I wanted to extend this access to an app I'd been messing about with so I could grant one time, short lived access to the development site, that was hosted on my homelab. I also wanted to make this access easier for me by using the same pattern of email based allow policy for myself (or another friend that might want continued access).  I was being overly cautious as I had not put much effort into hardening my internal server infra as nothing was open to internet (something that has very much changed now).
I ran into some quirks and gotchas when trying to configure the access policies, hopefully this can bring some illumination to others who get stuck as I did.

### The Goal
Lock a dev site so anyone can request access, but only I can approve it. 
I get straight through with no friction, only the expected MFA prompt.

### How to: Get this done
We are operating under the asumption that you have a cloudflare account and know how to setup a cloudflare tunnel and an application.  The scope here is just the zero trust confiuration.

1. Navigate to Cloudfalre's **Zero Trust** management page and open the **Access Controls** -> **Policies** menu.  
2. We will need to create 3 policies all together:
   1. 


### The Setup
- Enable One-time PIN as an identity provider
- Create the Access application for your dev site
- App Launcher policy: Allow your email only (required so Cloudflare recognises you as a valid approver)
- Policy 1 (precedence 1): Allow your email — permanent, no approval
- Policy 2 (precedence 2): Allow login methods (OTP) — everyone else, with temporary authentication and purpose justification enabled, approver set to your email

### The Gotchas
- Gmail `+` aliases don't work — Cloudflare treats them as the same identity
- You can't approve your own request — approver and requester must be distinct identities
- The App Launcher policy is mandatory — without it you get a "not allowed to approve" error even with different accounts
- The login methods include rule is the non-obvious missing piece — without it visitors get rejected before they can even submit a request