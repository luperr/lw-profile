# lw-profile

A personal blog/profile website built with Hugo, deployed to AWS S3, and managed with Terraform.

## 📋 Overview

This is a static site generator project using:
- **Hugo** - Static site generator (Go-based)
- **Hermit-v2 Theme** - Blog theme for Hugo
- **AWS S3** - Static website hosting
- **Terraform** - Infrastructure as Code for AWS resources
- **Docker** - Containerized development environment
- **GitHub Actions** - CI/CD for automated deployment

## 🚀 Quick Start

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

### Running Locally without Docker

```bash
# Install Hugo Extended
brew install hugo

# Run development server
hugo server

# Build for production
hugo --environment production --minify
```

## 🏗️ Project Structure

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

## 🛠️ Development

### Content Management

- **Create new post**: `hugo new posts/my-new-post.md`
- **Edit content**: Modify markdown files in `content/`
- **Preview**: Hugo auto-reloads on file changes

### Styling

Custom SCSS variables are in `assets/scss/_colors.scss`. These override theme defaults.

### Infrastructure

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

## 📦 Deployment

### Automated (GitHub Actions)

The site automatically deploys when:
- A PR to `main` is merged (production)
- Pushes to non-main branches (staging)

### Manual Deployment

```bash
# Build the site
hugo --environment production --minify

# Deploy to S3 (example)
aws s3 sync public/ s3://your-bucket-name --delete
```

## 🔧 Configuration

### Hugo Configuration

Main config: `hugo.toml`
- Base URL (currently needs production URL)
- Theme settings
- Language configuration
- SEO settings

### Terraform Configuration

- **Region**: `ap-southeast-4`
- **Environments**: `dev` and `prod`
- **Buckets**: `dev-lw-profile` and `prod-lw-profile`

### Environment Variables

For Terraform:
- `AWS_PROFILE=admin-prod` (or use AWS credentials)

For Hugo production builds:
- Set `HUGO_ENV=production` or use `--environment production`

## 📝 TODO / Known Issues

### 🔴 Critical Priority

- [ ] **Fix Hugo baseURL** - Currently set to `localhost`, breaks production builds and SEO
- [ ] **Fix Terraform bucket policy** - Add public `GetObject` access so website is actually viewable
- [ ] **Fix GitHub Actions workflow** - Use production environment and add validation

### 🟡 High Priority

- [ ] **Fix critical typos** - 'conrner' → 'corner' and LinkedIn URL missing `https://`
- [ ] **Configure denyRobots for production** - Currently blocking all search engines (should be dev-only)
- [ ] **Add Terraform encryption** - Add S3 bucket encryption configuration
- [ ] **Fix prod module settings** - Add missing public access block settings for production

### 🟢 Medium Priority

- [ ] **Create production config structure** - Set up environment-based Hugo config (`config/` directory)
- [ ] **Improve archetype template** - Add more useful frontmatter fields
- [ ] **Fix content typos** - Update `about.md` and test post content
- [ ] **Standardize frontmatter format** - Consistent YAML vs TOML usage
- [ ] **Add meta tags** - Improve SEO with proper Open Graph and Twitter Card tags
- [ ] **Complete multi-language setup** - Configure French and Italian languages properly


## 📚 Documentation

- [Hugo Documentation](https://gohugo.io/documentation/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions Hugo Setup](https://github.com/peaceiris/actions-hugo)


**Note**: This project is in active development. See TODO section above for known issues and planned improvements.

