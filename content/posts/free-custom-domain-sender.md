---
title: "Configuring A Custom Email Eending Domain For The Fiscally Responsible"
slug : "custom-email-sending-domain"
draft: false
featuredImg: ""
description : "I didn't want to pay for an email service provider so I found a workaround"
date: 2026-09-06
tags: 
    - project
scrolltotop : true
toc : false
mathjax : false
---

# Configuring a custom email sending domain for the fiscally responsible
I wanted to send emails from a custom domain without spending money or monitoring another mailbox. To avoid spending $5 a month for a paid email service or, even more foolishly, attempting to host my own email service. I strung together some config and a free service to emulate a custom email sending domain from my Gmail account.

## Pre-reqs
- Gmail as your primary inbox (I'm sure others could work too but this is the one I have).
- Own a domain.
- Cloudflare as your DNS provider.

## Inbound mail with Cloudflare routing
Cloudflare offers [email routing services](https://www.cloudflare.com/products/email-routing/) for domains using their DNS service.  The inbound service is free too, so this one was a no brainer.  Since DNS was already configured for me it took two minutes to configure.
In the portal under **compute** -> **email services** click onboard a domain and select the domain you want as a sender.  
Create a **destination address** and add your Gmail account here. (accept the verification email)
Finally, add a **routing rule** with the new custom email address (eg admin@somedomain.com)

We've now got inbound emails into our Gmail account. Bonus points, set up a rule in Gmail and you can easily seperate the emails out. 

## Outbound email
Conveniently, Gmail allows us to configure [**Send As**](https://support.google.com/mail/answer/22370?hl=en) addresses natively. For now at least anyway.  The trick here is just using Gmail's SMTP service as the sending SMTP server.
First, we need an application password. In google account setting search for **app password** and it'll let you make a password.  Keep this secret for now. 
Then in gmail open **settings -> All setting -> Accounts and Import -> Send As -> add another email address.**  
Setup the same sender address as in Cloudflare and for the server settings:
 - SMTP Server = smtp.gmail.com port 587
 - username = gmail account user name
 - password = the application password we created before

Save it and we've got outbound email from a custom sending address.  Be warned you cannot test it by sending from the same email account because Gmail filters it out of the inbox.

## We did it, but at what cost?
Do not be like me, just pay the monthly cost for a Proton account or use one of the volumed-based sending services. I will eventually migrate away from this, probably when Gmail changes it's policy and alters the Send As feature, but I'll cross that bridge when I come to it.