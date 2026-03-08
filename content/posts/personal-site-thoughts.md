---
title: "I Over-Engineered My Personal Website (And I Regret Nothing)"
slug : "test-dragon"
draft: false
featuredImg: ""
description : 'Summarising the things I made for my personal site/blog'
tags: 
    - project
scrolltotop : true
toc : false
mathjax : false
---
# I Over-Engineered My Personal Website (And I Regret Nothing)

I wanted a demo project to showcase my DevOps skills. I didn't mind what was deployed, it could've been a single HTML page that says "hello world" and I'd have been happy. So I went for a static site (my now personal website) deployed in the most over-engineered way possible. Did I need to? Absolutely not. Here's what I built anyway.

---

## The Stack

- **Terraform** - because if it's not code, does it even exist?
- **GitHub Actions** - CI/CD stack I wanted to use
- **Hugo** - gotta have a site to deploy
- **AWS** - S3 for hosting, cheap and reliable
- **Cloudflare** - free CDN, and it's already where all my DNS lives

---

## The Decisions

### Hosting

S3 was the obvious choice for a static site if you want to keep costs low. It's not the most exciting Terraform to write, but sometimes you've got to make sacrifices to stay affordable.

There's one gotcha worth knowing: S3 static website hosting uses the `Host` header to identify which bucket to serve. Cloudflare passes the domain as the `Host` header, which means your bucket names **must exactly match your domain names**. It is possible to try and modifier they header with CloudFlare but that seemed silly when you I just needed to new buckets.  It was literally a variable change in the Terraform.

Both buckets are managed as a reusable Terraform module. Each instance gets static website hosting configured with `index.html` and `error.html`, a `public-read` ACL, and a Cloudflare IP allowlist baked into the bucket policy.

Terraform state lives in a separate S3 bucket; Nothing fancy, just the standard remote backend setup so state doesn't live on someone's laptop. I need to retain the state since all the I deployed all the security rules and roles as terraform and we can't be redeploying the roles that allow AWS and Github to talk to each other each time I merged to main.

### The Pipeline

This is where most of the effort went. The workflow has four jobs: `build`, `plan`, `apply`, and `deploy`. Chaining them together is where I had lots of fun and tweaking.

**Build** runs on every push and PR. It uses `peaceiris/actions-hugo@v3` to set up Hugo extended, detects whether we're targeting prod or dev based on the branch, and builds the site with the correct `--baseURL` and `--environment` flags. The output gets uploaded as an artifact for the deploy job to consume later.

**Plan** also runs on every push and PR. It authenticates to AWS via OIDC (no stored credentials — more on that below), then runs `terraform fmt`, `init`, `validate`, and `plan`. The plan output is saved as an artifact and, on PRs, automatically posted as a comment so you can see exactly what will change before merging. The plan uses `-detailed-exitcode` so downstream jobs can distinguish between "no changes", "changes detected", and "plan failed".

**Apply** only runs on push to `main`, and only if the plan succeeded. It's gated behind a GitHub Actions environment called `terraform-apply`, which means you can require manual approval before any infrastructure change goes through. It downloads the saved plan artifact and applies it - so what you reviewed is exactly what gets applied, no surprises.

**Deploy** runs last, after build, plan, and apply have all completed (or apply was skipped on a non-main branch). It downloads the Hugo build artifact and syncs it to the correct S3 bucket. On `develop` it goes to `dev.lachlannwhitehill.com`, on `main` it goes to prod. 

### Authentication — No Long-Lived Keys

GitHub Actions authenticates to AWS using **OIDC**, not stored access keys. The Terraform config provisions an IAM OIDC identity provider pointing at `token.actions.githubusercontent.com`, and an IAM role that can only be assumed by workflows running from `repo:luperr/lw-profile:*`. GitHub mints a short-lived token per job run, exchanges it for temporary AWS credentials via `sts:AssumeRoleWithWebIdentity`, and the whole thing works without a single long-lived secret anywhere in the repo.

The IAM role has a tightly scoped inline policy `s3:GetObject`, `PutObject`, `DeleteObject`, `ListBucket`, and `GetBucketLocation` on the two site buckets, plus the same on the Terraform state bucket. Nothing more than it needs.

### Security — Cloudflare-Only Origin

The S3 buckets have public ACLs, but the bucket policy only allows traffic from Cloudflare's published IP ranges. All 22 of them — both IPv4 and IPv6 — are hardcoded as a local in `main.tf` and passed into the bucket module. Any request that doesn't come through Cloudflare gets a 403 at the bucket level. The origin is never directly reachable.

On top of that, the dev site sits behind Cloudflare Zero Trust access. It's not indexed, it's not linked anywhere, and you need to authenticate to see it. Probably overkill for a personal dev environment, but it was free and it took about ten minutes to set up.

### Hugo Config

Hugo is set up with the `hermit-v2` theme, tweaked to match Gruvbox theme, my terminal colour scheme of choice.  I would like to spend more time getting better at site design but if it works it works.

### The Dockerfile

I also built a Dockerfile for local development, I keep swapping dev devices and hate having to install anything locally. It installs Go, Terraform, AWS CLI v2, and Hugo extended into a single Ubuntu 24.04 image, copies in the site config and content, and runs `hugo server` bound to `0.0.0.0` so it's reachable from the host. It's pinned to the same Hugo version (`0.152.2`) as the Actions workflow so local and CI builds are always consistent. 

## Where This Is Going

The pipeline is already fairly easy to spin up, but next steps I want to IaC the entire site setup via a pipeline.  Just stamp out new sites at the click of a deploy button. New repo, everything populated via a a small config file.  Sounds like a fun project.

After that, a headless CMS like Decap would make it accessible to people who don't live in a terminal. Right now it's a very git-native workflow, which suits me fine, but isn't exactly friendly to anyone else.  It would be good to be able to make sites for my non-technical friends that can self-service their sites after I configure them.

And yeah, I'll probably end up Terraforming the Cloudflare DNS and Zero Trust config too. Just for completeness.