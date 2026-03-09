# lw-profile

A personal blog/profile website built with Hugo, deployed to AWS S3, and managed with Terraform. Automatically deployed with GitHub Actions.

## 📋 Overview

This is a static site generator project using:
- **Hugo** - Static site generator (Go-based)
- **Hermit-v2 Theme** - Blog theme for Hugo
- **AWS S3** - Static website hosting
- **Terraform** - Infrastructure as Code for AWS resources
- **GitHub Actions** - CI/CD for automated deployment

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

NOTES
-----
- S3 bucket names must match the domain name exactly for Cloudflare proxying to work

OPTIONAL
--------
[ ] Implement Lambda for Cloudflare IP auto-updates
