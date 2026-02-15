# lw-profile

A personal blog/profile website built with Hugo, deployed to AWS S3, and managed with Terraform.

## 📋 Overview

This is a static site generator project using:
- **Hugo** - Static site generator (Go-based)
- **Hermit-v2 Theme** - Blog theme for Hugo
- **AWS S3** - Static website hosting
- **Terraform** - Infrastructure as Code for AWS resources
- **GitHub Actions** - CI/CD for automated deployment

## Quick Start

### Prerequisites

- Docker Desktop (for macOS)
- Terraform (if running locally)
- Hugo Extended (if running locally)

### Running Locally with Docker

```bash
# Build the Docker image
docker build -t lw-profile .

# Run Hugo development server
docker run -p 1313:1313 --name lw-profile-hugo lw-profile

# Access at http://localhost:1313
```

## Project Structure

```
lw-profile/
├── .github/workflows/    # GitHub Actions CI/CD
├── archetypes/           # Hugo content templates
├── assets/               # SCSS styles and assets
├── content/              # Site content (markdown)
│   ├── about.md
│   └── posts/
├── public/               # Generated static site (gitignored)
├── resources/            # Hugo-generated resources
├── terraform/            # Infrastructure as Code
│   ├── main.tf           # Main Terraform config
│   └── modules/          # Reusable Terraform modules
└── themes/hermit-v2/     # Hugo theme
```

### Automated Deployment (GitHub Actions)

The site automatically deploys when:
- A PR to `main` is merged (production)
- Pushes to non-main branches (staging)


CRITICAL PATH TO LIVE SITE
--------------------------
[x] Get domain name ready (lachlannwhitehill.com)
[x] Update hugo.toml baseURL to production domain
[x] Fix robots.txt blocking in hugo.toml
[x] Update GitHub Actions workflow for OIDC and branch-based deployment
[ ] Setup AWS OIDC provider and IAM role in Terraform
[ ] Update S3 bucket policy to allow Cloudflare IPs or public access
[ ] Add public access block settings to prod terraform module
[ ] Run terraform apply to create infrastructure
[ ] Configure GitHub Actions secrets (AWS_ROLE_ARN, AWS_REGION, S3 buckets)
[ ] Test deployment to dev
[ ] Configure Cloudflare DNS CNAME to S3 endpoint
[ ] Enable Cloudflare proxy (orange cloud)
[ ] Set Cloudflare SSL to "Full"
[ ] Deploy to production (merge to main)
[ ] Verify site is live

OPTIONAL
--------
[ ] Add real content to about.md
[ ] Create blog posts
[ ] Add Cloudflare page rules for caching
[ ] Implement Lambda for Cloudflare IP auto-updates
[ ] Add encryption to S3 buckets