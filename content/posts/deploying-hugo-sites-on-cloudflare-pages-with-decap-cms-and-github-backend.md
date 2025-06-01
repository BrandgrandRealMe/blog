---
title: Deploying Hugo Sites on Cloudflare Pages with Decap CMS and GitHub Backend
date: 2025-06-01T15:09:59.162Z
tags:
  - Blog
  - CMS
  - Hugo
  - DecapCMS
draft: false
description: Learn how to build and deploy a fast, cost-free blog using Hugo,
  Cloudflare Pages, and Decap CMS with a GitHub backend. This updated guide
  (June 2025) covers setting up a Hugo site, deploying it on Cloudflare Pages,
  and integrating Decap CMS for easy content management. Ideal for developers
  and content creators, this tutorial offers a modern, scalable workflow
  leveraging free tiers, with optional GitHub OAuth for secure multi-user
  access.
---
Recently, I made this blog with Hugo, a powerful static site generator known for its speed and flexibility. By combining Hugo with Cloudflare Pages for hosting and Decap CMS (formerly Netlify CMS) with a GitHub backend for content management, I created a fast, scalable, and cost-effective solution for managing my blog. In this guide, I’ll walk you through the process of setting up and deploying a Hugo site on Cloudflare Pages, integrating Decap CMS for a user-friendly content editing experience, and using GitHub as the backend for content storage—all at zero cost.

This updated guide reflects the latest tools and configurations as of June 2025, including improvements in Hugo’s CLI, Cloudflare Pages’ deployment options, and Decap CMS’s integration with GitHub. Whether you’re a developer or a content creator, this setup offers a robust, modern workflow for building and managing static websites.

## Why Choose Hugo, Cloudflare Pages, and Decap CMS?

* **Hugo**: A blazing-fast static site generator that produces lightweight, secure sites with minimal server overhead. Its active community and extensive theme ecosystem make it ideal for blogs and portfolios.
* **Cloudflare Pages**: Offers seamless integration with Git providers, automatic scaling, and a generous free tier, making it a top choice for hosting static sites. Recent updates in 2025 enhance build speeds and preview deployments.
* **Decap CMS**: A lightweight, open-source CMS that integrates with GitHub for content management. It provides a user-friendly interface for non-technical editors while keeping content in version control.
* **GitHub**: Serves as the backend for storing content and site code, with optional OAuth authentication for secure access to Decap CMS in collaborative setups.

This stack is cost-effective ($0 with free tiers), developer-friendly, and optimized for performance. Let’s dive into the setup process.

## Prerequisites

Before starting, ensure you have the following:

* A GitHub account and a repository for your Hugo site.
* Hugo CLI installed (version 0.139.0 or later recommended for 2025 compatibility).
* A Cloudflare account with access to Cloudflare Pages.
* Basic familiarity with Git, command-line tools, and static site generators.
* Node.js (optional, for local Decap CMS development).

## Step-by-Step Guide

### Step 1: Set Up a Hugo Site Locally

1. **Install Hugo**:

   * On macOS/Linux: Use Homebrew (`brew install hugo`) or download the binary from [Hugo’s releases page](https://github.com/gohugoio/hugo/releases).
   * On Windows: Use `winget install Hugo.Hugo.Extended` or download the extended version for SCSS processing.
   * Verify installation: `hugo version` (ensure it’s 0.139.0 or newer).
2. **Create a New Hugo Site**:

   ```bash
   hugo new site my-hugo-site
   cd my-hugo-site
   ```

   This creates a basic Hugo project structure.
3. **Add a Theme**:

   * Choose a theme from [Hugo Themes](https://themes.gohugo.io/). For this guide, we’ll use the `Ananke` theme.
   * Clone the theme into your project:

     ```bash
     git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
     ```
   * Update `config.toml` to use the theme:

     ```toml
     theme = "ananke"
     ```
4. **Test Locally**:

   * Run `hugo server` to preview your site at `http://localhost:1313`.
   * Create a sample post to test:

     ```bash
     hugo new posts/my-first-post.md
     ```
   * Edit the post in `content/posts/my-first-post.md` and verify it appears in the local preview.

### Step 2: Initialize Git and Push to GitHub

1. **Initialize a Git Repository**:

   ```bash
   git init
   git add .
   git commit -m "Initial Hugo site setup"
   ```
2. **Create a GitHub Repository**:

   * Go to GitHub and create a new repository (e.g., `my-hugo-site`).
   * Push your local repository:

     ```bash
     git remote add origin https://github.com/BrandgrandRealMe/my-hugo-site.git
     git branch -M main
     git push -u origin main
     ```

### Step 3: Deploy to Cloudflare Pages

1. **Connect to Cloudflare Pages**:

   * Log in to your Cloudflare account and navigate to the *Pages* tab.
   * Click *Create a project* and select *Connect to Git*.
   * Authorize Cloudflare to access your GitHub repository and select `my-hugo-site`.
2. **Configure Build Settings**:

   * **Project Name**: `my-hugo-site`
   * **Production Branch**: `main`
   * **Build Command**: `hugo --gc --minify` (ensures clean, optimized output).
   * **Build Output Directory**: `public`
   * **Environment Variables** (optional):

     * Add `HUGO_VERSION=0.139.0` to ensure the correct Hugo version.
   * Save and deploy. Cloudflare Pages will build and deploy your site, providing a URL (e.g., `my-hugo-site.pages.dev`).
3. **Verify Deployment**:

   * Once the build completes (typically 1-2 minutes), visit the provided URL to confirm your site is live.
   * Cloudflare Pages automatically deploys updates when you push changes to the `main` branch.

### Step 4: Integrate Decap CMS

1. **Install Decap CMS**:

   * Add the Decap CMS files to your Hugo site:

     ```bash
     mkdir -p static/admin
     curl -o static/admin/index.html https://raw.githubusercontent.com/decaporg/decap-cms/master/packages/decap-cms/index.html
     curl -o static/admin/config.yml https://raw.githubusercontent.com/decaporg/decap-cms/master/packages/decap-cms/config.yml
     ```
2. **Configure Decap CMS**:

   * Edit `static/admin/config.yml` to connect to your GitHub repository:

     ```yaml
     backend:
       name: github
       repo: BrandgrandRealMe/my-hugo-site
       branch: main
     media_folder: "static/images/uploads"
     public_folder: "/images/uploads"
     collections:
       - name: "posts"
         label: "Posts"
         folder: "content/posts"
         create: true
         slug: "{{slug}}"
         fields:
           - { label: "Title", name: "title", widget: "string" }
           - { label: "Publish Date", name: "date", widget: "datetime" }
           - { label: "Body", name: "body", widget: "markdown" }
     ```
3. **GitHub Authentication for Decap CMS**:

   * For **single-user setups** (e.g., you’re the repository owner), Decap CMS often works without additional configuration when deployed on Cloudflare Pages. The GitHub integration in Cloudflare Pages can handle authentication for the CMS at `your-site.pages.dev/admin`.
   * For **multi-user or public sites**, you’ll need to set up OAuth for secure GitHub authentication:

     * Create a GitHub OAuth App (GitHub Settings > Developer Settings > OAuth Apps) to obtain a `Client ID` and `Client Secret`.
     * Add GitHub Credentials to Cloudflare Pages:

       * In your Cloudflare Pages project settings, navigate to *Environment Variables*.
       * Add `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` as secrets, using the `Client ID` and `Client Secret` from your GitHub OAuth application.
     * Update `static/admin/config.yml` to enable OAuth:

       ```yaml
       backend:
         name: github
         repo: BrandgrandRealMe/my-hugo-site
         auth_type: implicit
       ```
     * The `auth_type: implicit` setting allows Decap CMS to use the credentials stored in Cloudflare Pages for authentication.
   * If you’re the sole editor and encounter no login issues, you can skip this OAuth step.
4. **Test Decap CMS Locally**:

   * Install the `npx` command-line tool if not already installed (`npm install -g npx`).
   * Run `npx decap-server` in your project root to simulate the CMS backend.
   * Access `http://localhost:1313/admin` to log in via GitHub and test the CMS interface.
5. **Deploy Changes**:

   * Commit and push the updated files:

     ```bash
     git add .
     git commit -m "Add Decap CMS"
     git push origin main
     ```
   * Cloudflare Pages will rebuild the site, and Decap CMS will be accessible at `your-site.pages.dev/admin`.

### Step 5: Customize and Optimize

1. **Customize Your Theme**:

   * Modify the theme’s templates in `themes/ananke` or create overrides in your project’s `layouts` directory.
   * Update `config.toml` for site-wide settings like title, menus, or analytics.
2. **Optimize Performance**:

   * Use Hugo’s `--minify` flag to reduce HTML, CSS, and JavaScript output.
   * Leverage Cloudflare’s CDN features, such as image optimization and caching, to improve load times.
   * Enable Cloudflare’s *Smart Tiered Cache* for faster global delivery.
3. **Enable Preview Deployments**:

   * In Cloudflare Pages, enable preview deployments for non-production branches (e.g., `staging`).
   * This allows content editors to preview changes via Decap CMS before merging to `main`.

### Step 6: Content Management with Decap CMS

* Access the CMS at `your-site.pages.dev/admin`.
* Log in with your GitHub account.
* Create or edit posts using the intuitive interface. Changes are saved as commits to your GitHub repository, triggering automatic rebuilds on Cloudflare Pages.
* Non-technical users can manage content without touching code, while developers retain full control via Git.

## Troubleshooting Tips

* **Build Failures**: Check Cloudflare’s build logs for errors. Common issues include missing `HUGO_VERSION` or incorrect build output directory (`public`).
* **Decap CMS Login Issues**: If you skipped OAuth setup and can’t log in, ensure you’re the repository owner and Cloudflare Pages has GitHub access. For multi-user setups, verify `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` are correctly set in Cloudflare Pages’ environment variables.
* **Content Not Updating**: Confirm the `media_folder` and `public_folder` paths in `config.yml` match your Hugo setup.
* **Performance Issues**: Use Hugo’s `--enableGitInfo` flag to reduce build times for large repositories.

## Recent Updates (June 2025)

* **Hugo 0.139.0**: Improved build performance and support for modern JavaScript modules.
* **Cloudflare Pages**: Enhanced preview deployment features and faster build times with updated Workers runtime.
* **Decap CMS**: Streamlined GitHub integration, with simpler authentication for single-user setups. Community feedback on X highlights smoother Cloudflare Pages integrations.
* **GitHub**: Improved Actions for CI/CD, which can complement Cloudflare Pages for automation.

## Conclusion

By combining Hugo’s speed, Cloudflare Pages’ scalability, and Decap CMS’s ease of use, you can build a modern, cost-effective static site with a robust content management workflow. This setup is ideal for personal blogs, portfolios, or small business sites, offering flexibility for developers and simplicity for content editors. The entire process leverages free tiers, making it accessible to everyone.

For further reading, check out:

* [Hugo Documentation](https://gohugo.io/documentation/)
* [Cloudflare Pages Docs](https://developers.cloudflare.com/pages/)
* [Decap CMS Docs](https://www.decapcms.org/docs/intro/)
* [Original Blog Post](https://www.abhishek-tiwari.com/deploying-hugo-sites-on-cloudflare-pages-with-decap-cms-and-github-backend/)
* [My GitHub Repository](https://github.com/BrandgrandRealMe/my-hugo-site)

- - -

Citations:
Tiwari, Abhishek. 'Deploying Hugo Sites on Cloudflare Pages with Decap CMS and GitHub Backend'. Abhishek Tiwari, December 2024. https://doi.org/10.59350/dp6cx-sma35.
