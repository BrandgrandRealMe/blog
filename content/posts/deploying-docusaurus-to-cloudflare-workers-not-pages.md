---
title: Deploying Docusaurus to Cloudflare Workers (Not Pages!)
date: 2025-06-06T13:39:51.978Z
tags:
  - Docusaurus
  - Cloudflare Workers
  - Serverless
  - Static Site Generation
  - Deployment
draft: false
description: Discover how to leverage the power and flexibility of Cloudflare
  Workers to host your Docusaurus site, going beyond the traditional Cloudflare
  Pages approach for more control and advanced use cases, while still delivering
  a fast, static experience.
---
So you've built an amazing documentation site with Docusaurus, and now it's time to unleash it onto the world! Cloudflare offers fantastic solutions for hosting static sites, with [Cloudflare Pages](https://pages.cloudflare.com/) being the go-to for many. **For most standard Docusaurus deployments, Cloudflare Pages is indeed the simplest and recommended "normal" path.** It provides integrated CI/CD, automatic deployments from Git, and a streamlined experience that will serve your static site perfectly.

However, what if you need a little more control, want to integrate with other Worker-based logic, or simply prefer the raw power of Workers for your static deployments? This article will guide you through deploying your Docusaurus site directly to Cloudflare Workers, bypassing Cloudflare Pages. **Rest assured, your Docusaurus site will still act like a perfectly normal, fast, and globally available static website.** We're just using a different mechanism on Cloudflare's edge to serve it.

### Why Workers Over Pages for Docusaurus? (And When to Stick with Pages)

Cloudflare Pages is undoubtedly convenient. It offers integrated CI/CD, automatic deployments from Git, and a streamlined experience designed specifically for static site generators like Docusaurus. **If your primary goal is just to get your Docusaurus site online with minimal fuss and automatic updates from Git, Cloudflare Pages is likely your best choice.** It abstracts away much of the complexity you'll encounter with Workers.

However, there are specific scenarios where deploying your Docusaurus site directly to Cloudflare Workers might be a better fit, even though it involves a bit more setup:

*   **Custom Logic:** You might want to pre-process requests, add custom headers, implement advanced caching strategies, or even serve different content based on user location or other dynamic factors, all within the Worker. This goes beyond simple static serving.
*   **Monorepos:** If your Docusaurus site is part of a larger monorepo with other Worker applications, deploying it as a Worker can simplify your deployment architecture, allowing all your edge logic to reside in a single Worker project.
*   **Granular Control:** Workers provide a lower-level API, giving you more precise control over how your site is served, which can be useful for very specific performance optimizations or routing requirements.
*   **Integrating with other Workers:** If your documentation needs to interact with other serverless functions deployed as Workers (e.g., pulling data from a backend API also powered by Workers), having them in the same Worker context can simplify inter-service communication and reduce latency.
*   **Not using Git for deployment:** While not typical for Docusaurus, if your build and deployment process isn't tied to a Git repository, Workers give you more flexibility in how you push updates.

**In summary: Cloudflare Pages is ideal for "set it and forget it" Docusaurus deployments tied to Git. Cloudflare Workers is for when you need to layer custom logic on top of your static site, integrate it deeply with other serverless functions, or require more granular control over the serving process.** Despite the underlying mechanism, the end result is still a super fast, globally distributed static Docusaurus site.

### The Challenge: Workers Expect JavaScript, Docusaurus Generates HTML

Cloudflare Workers execute JavaScript (or other WebAssembly languages). Docusaurus, on the other hand, generates a collection of static HTML, CSS, JavaScript, and asset files. The trick is to serve these static files *from* your Worker. We'll achieve this by leveraging the `files` binding in `wrangler.toml` and clever routing within our Worker script.

### Step 1: Build Your Docusaurus Site

First things first, ensure your Docusaurus site is built and ready for deployment. Navigate to your Docusaurus project directory and run:

```bash
npm run build
# or
yarn build
```

This command will generate a `build` directory (or whatever you've configured as your `outDir` in `docusaurus.config.js`) containing all the static assets of your site.

### Step 2: Initialize Your Cloudflare Worker Project

If you don't already have `wrangler` installed, do so:

```bash
npm install -g wrangler
```

Now, initialize a new Worker project in a directory *outside* of your Docusaurus project (or within it, if you prefer, but keep your Docusaurus build output separate).

```bash
mkdir docusaurus-worker-deployment
cd docusaurus-worker-deployment
wrangler init
```

Follow the prompts. Choose "yes" when asked if you want to deploy a Worker. This will create a `src/index.js` file and a `wrangler.toml` file.

### Step 3: Configure `wrangler.toml` for Static Asset Serving

This is the crucial step. We need to tell Wrangler to bundle our Docusaurus `build` directory with our Worker. We'll use a `kv_namespaces` binding, but specifically the `asset_namespaces` type which is designed for serving static assets.

Open your `wrangler.toml` file and add the following:

```toml
name = "my-docusaurus-worker" # Replace with your desired Worker name
main = "src/index.js"
compatibility_date = "2024-01-01" # Use a recent date

[vars]
# You can add environment variables here if needed

[[kv_namespaces]]
binding = "DOCUSAURUS_ASSETS" # This is the variable name your Worker will use to access the assets
id = "<YOUR_KV_NAMESPACE_ID>" # You'll generate this next
prefix = "" # Keep this empty to serve from the root

# Add the following for static asset serving
[site]
bucket = "../path/to/your/docusaurus/build" # IMPORTANT: Adjust this path to your Docusaurus build directory
entrypoint = "index.html" # Default entry point for your Docusaurus site
```

**Key adjustments:**

*   **`bucket`**: This path *must* point to your Docusaurus `build` directory. If your Worker project is in a sibling directory to your Docusaurus project, it might look like `../my-docusaurus-project/build`.
*   **`id`**: You need to create a KV namespace. Run the following command:
    ```bash
    wrangler kv namespace create DOCUSAURUS_ASSETS
    ```
    This will output an `id`. Copy that `id` and paste it into your `wrangler.toml` file.

### Step 4: Write the Worker Script (`src/index.js`)

Now, we'll write the Worker script that serves the static assets. Cloudflare provides a convenient `getAssetFromKV` function that makes this incredibly easy.

```javascript
import { getAssetFromKV, serveSinglePageApp } from '@cloudflare/kv-asset-handler';

addEventListener('fetch', event => {
  try {
    event.respondWith(handleEvent(event));
  } catch (e) {
    event.respondWith(new Response('Internal Error', { status: 500 }));
  }
});

async function handleEvent(event) {
  const url = new URL(event.request.url);
  let options = {};

  try {
    // Attempt to serve the asset directly from KV
    return await getAssetFromKV(event, options);
  } catch (e) {
    // If the asset isn't found directly (e.g., for client-side routes like /docs/intro on refresh),
    // try serving the main single-page application entry point (index.html).
    // This allows Docusaurus's client-side router to take over.
    try {
      let notFoundResponse = await getAssetFromKV(event, {
        mapRequestToAsset: serveSinglePageApp,
      });
      // The `serveSinglePageApp` helper often returns a 404 status initially,
      // but if it successfully finds the index.html, we should change the status to 200.
      if (notFoundResponse.status === 404) {
         // If it's truly a 404 for the index.html, we handle it as a final fallback.
         throw new Error("No index.html found after SPA fallback attempt.");
      }
      return new Response(notFoundResponse.body, {
          status: 200, // Important: Change status to 200 for successful SPA serves
          headers: notFoundResponse.headers
      });
    } catch (e) {
      const pathname = url.pathname;
      // You can customize your 404 page here, e.g., redirect to /404.html
      // return new Response(`Page not found: ${pathname}`, {
      //   status: 404,
      //   headers: { 'Content-Type': 'text/plain' },
      // });
      // Or, fetch a custom 404.html if it exists in your Docusaurus build
      try {
        const custom404 = await getAssetFromKV(event, {
          mapRequestToAsset: req => new Request(`${url.origin}/404.html`, req),
        });
        return new Response(custom404.body, {
          status: 404,
          headers: custom404.headers,
        });
      } catch (innerError) {
        // If 404.html also doesn't exist, return a generic 404
        return new Response(`Page not found: ${pathname}`, {
          status: 404,
          headers: { 'Content-Type': 'text/plain' },
        });
      }
    }
  }
}
```

**Explanation:**

*   **`@cloudflare/kv-asset-handler`**: This library is specifically designed for serving static assets stored in KV.
*   **`getAssetFromKV(event, options)`**: This is the core function. It tries to find a matching asset in your KV namespace (bound via `DOCUSAURUS_ASSETS`).
*   **`serveSinglePageApp`**: Docusaurus, like many static site generators, is a Single Page Application (SPA). If a direct asset isn't found (e.g., a user navigates directly to `/docs/intro` and refreshes), we use `serveSinglePageApp` to redirect all non-matching paths to `index.html`. This allows Docusaurus's client-side router to handle the routing. I've added a crucial `status: 200` change here, as `serveSinglePageApp` can sometimes return a 404 if the initial path doesn't match a direct asset, but it successfully finds `index.html`.
*   **Enhanced 404 Handling**: The updated script now attempts to serve a `404.html` file from your Docusaurus build if a direct asset or SPA fallback fails. This provides a more user-friendly error page.

### Step 5: Deploy Your Docusaurus Worker!

Finally, it's time to deploy. From your Worker project directory, run:

```bash
wrangler deploy
```

Wrangler will package your Worker script, upload your Docusaurus build output to the KV namespace, and deploy your Worker.

### What's Happening Under the Hood?

When you deploy with the `[site]` configuration in `wrangler.toml`:

1.  Wrangler takes the contents of your Docusaurus `build` directory.
2.  It uploads these files to the KV namespace specified by `id` in your `wrangler.toml`.
3.  Your Worker script then uses `getAssetFromKV` to fetch these files from KV and serve them to incoming requests.

This creates a powerful and highly performant way to serve your static Docusaurus site globally via Cloudflare's edge network, all within the flexible environment of a Cloudflare Worker.

### Considerations and Next Steps

*   **Custom Domains:** After deployment, you can configure a custom domain for your Worker via the Cloudflare dashboard.
*   **Cache Control:** You can add more sophisticated cache control headers within your Worker script to optimize content delivery.
*   **Version Control & CI/CD:** For a more robust setup, integrate this deployment process into your CI/CD pipeline (e.g., GitHub Actions, GitLab CI) to automatically rebuild and deploy your Docusaurus site and Worker on every commit.
*   **Security Headers:** Enhance your site's security by adding custom security headers in your Worker.
*   **Environment Variables:** If your Docusaurus site needs access to environment variables, you can pass them from your Worker script (e.g., by fetching them from `event.request.headers` or using `wrangler.toml`'s `[vars]` section).
*   **Advanced Routing:** For more complex routing scenarios, you can write custom logic in your Worker to serve different versions of your site or redirect based on various conditions.

Deploying Docusaurus to Cloudflare Workers might take a few more steps than Pages, but it unlocks a world of possibilities for customization, integration, and fine-grained control over your documentation's deployment. Enjoy the power of the edge!
