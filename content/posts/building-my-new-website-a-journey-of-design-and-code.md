---
title: "Building My New Website: A Journey of Design and Code"
date: 2025-06-05T14:38:27.676Z
tags:
  - web development
  - JavaScript
  - Markdown
  - theme toggle
  - responsive design
  - CSS
  - HTML
draft: false
description: Discover the process of creating my new website, brandgrand.rocks,
  from designing a responsive homepage to building a Markdown editor and rich
  text converter, complete with a persistent theme toggle.
---


Hey there, tech enthusiasts! I'm Brandon, and I'm thrilled to share the story of how I built my new website, [brandgrand.rocks](https://brandgrand.rocks). This project was a labor of love, blending modern web design, functional tools, and a touch of personal flair. From crafting a sleek homepage to developing a streamlined rich text to Markdown converter, here's a behind-the-scenes look at the process, challenges, and triumphs. Grab a coffee, and let's dive in!

## The Vision: A Digital Hub for My Universe

My goal was to create a central hub that showcases my digital spaces, projects, communities, and tools. I wanted a site that was clean, responsive, and user-friendly, with a modern aesthetic that reflects my tech-savvy personality. Key features included:

- **Subdomains and Projects**: Links to my blog, shop, portfolio, games, and more, presented as clickable cards.
- **Community Links**: Invitations to join my Discord, Revolt, and Telegram communities, organized by platform.
- **Tools**: A Markdown editor and a rich text to Markdown converter for writers and developers.
- **Theme Toggle**: A light/dark mode switch with persistent user preferences, using intuitive sun/moon icons.

The site needed to be accessible, fast, and maintainable, with a consistent design across all pages. I chose HTML, CSS, and JavaScript for their simplicity and universal compatibility, avoiding heavy frameworks to keep things lightweight.

## Step 1: Designing the Homepage

The homepage (`index.html`) is the heart of [brandgrand.rocks](https://brandgrand.rocks). I started with a wireframe: a centered container with a bold title, an introductory paragraph, and sections for subdomains, communities, projects, and tools. Each section would use a grid of clickable cards for a modern, interactive feel.

### Design Choices
- **Color Scheme**: I defined a primary color (`#0004a9` for light mode, `#4d8cff` for dark mode) using CSS custom properties (`--ifm-color-primary`). This ensured easy theme switching and consistency across elements like headings, links, and buttons.
- **Typography**: I used system fonts (`-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`) for fast loading and a native look across devices.
- **Cards**: Each card has a hover effect (`transform: translateY(-6px)` and increased shadow) to make interactions engaging. The grid layout (`grid-template-columns: repeat(auto-fit, minmax(250px, 1fr))`) ensures responsiveness, collapsing to a single column on mobile.
- **Theme Toggle**: Initially a text button ("Toggle Theme"), I upgraded it to a circular button with sun/moon icons, enhancing visual appeal and intuition.

### Technical Implementation
The HTML structure is straightforward:
```html
<div class="container">
    <h1>Brandon's Directory</h1>
    <p class="intro">Discover my digital spaces, projects, and tools below.</p>
    <h2>Explore My Subdomains</h2>
    <ul class="subdomain-list">
        <li><a href="https://blog.brandgrand.rocks"><span>Blog</span><p>Read my latest articles...</p></a></li>
        <!-- More subdomains -->
    </ul>
    <!-- Communities, Projects, Tools sections -->
</div>
```
CSS handles the layout and theming:
```css
:root {
    --ifm-color-primary: #0004a9;
    /* Other color variables */
}
[data-theme='dark'] {
    --ifm-color-primary: #4d8cff;
}
.subdomain-list {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
}
.subdomain-list li {
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}
[data-theme='dark'] .subdomain-list li {
    background: #2d3748;
}
```
JavaScript, now in `/scripts/global.js`, manages the theme toggle:
```javascript
function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
}

// Set initial theme
const savedTheme = localStorage.getItem('theme');
if (savedTheme) {
    document.documentElement.setAttribute('data-theme', savedTheme);
} else {
    const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    document.documentElement.setAttribute('data-theme', systemPrefersDark ? 'dark' : 'light');
}
```
I used `localStorage` to save the user's theme preference, ensuring it persists across sessions. On page load, the script checks for a saved theme or falls back to the system preference (`prefers-color-scheme`).

### Challenges
- **Responsive Design**: Ensuring the grid layout worked seamlessly on all screen sizes was tricky. I tested extensively on mobile devices, adjusting padding and font sizes for smaller screens.
- **Community Section**: Organizing Discord, Revolt, and Telegram links into a cohesive layout required a nested structure (`platform-section` and `community-list`). I used SVGs for platform icons to keep them crisp and lightweight.
- **Favicon Integration**: Adding favicons (`apple-touch-icon`, `favicon-32x32`, etc.) and a web manifest ensured a polished experience across devices, but required careful path management (`/favicon/`).

## Step 2: Building the Markdown Editor

The Markdown editor (`markdown-editor.html`) was designed for writers who want to write and preview Markdown in real-time. I aimed for a side-by-side layout: a `textarea` for input and a `div` for the rendered HTML preview.

### Implementation
I used the `marked` library for Markdown parsing and `DOMPurify` for sanitizing HTML output to prevent XSS attacks:
```html
<div class="markdown-editor">
    <div class="editor-column">
        <textarea id="markdown-input" placeholder="Write your Markdown here..."></textarea>
    </div>
    <div class="preview-column">
        <div id="markdown-preview" class="markdown-preview"></div>
    </div>
</div>
```
JavaScript handles real-time updates:
```javascript
const markdownInput = document.getElementById('markdown-input');
const markdownPreview = document.getElementById('markdown-preview');
markdownInput.addEventListener('input', () => {
    const htmlOutput = marked.parse(markdownInput.value);
    markdownPreview.innerHTML = DOMPurify.sanitize(htmlOutput);
});
```
The CSS mirrors the homepage, with a flexbox layout (`display: flex`) that stacks vertically on mobile (`flex-direction: column` at `max-width: 768px`). The theme toggle and back link (`← Back to Brandon's Directory`) ensure consistency.

### Challenges
- **Library Integration**: Loading `marked` and `DOMPurify` via CDN was simple, but I ensured compatibility with older browsers by choosing stable versions (`marked@4.0.12`, `DOMPurify@2.3.6`).
- **Preview Styling**: Ensuring the preview matched the input’s typography and spacing required custom styles for headings and lists in the `.markdown-preview` div.
- **Performance**: For large Markdown inputs, real-time rendering could lag. I planned for future optimization with debouncing.

## Step 3: Creating the Rich Text to Markdown Converter

The rich text to Markdown converter (`richtext-to-markdown.html`) lets users paste rich text content and instantly see the Markdown equivalent. It features a simplified toolbar with “Clear” and “Copy Markdown” buttons, focusing on conversion rather than in-browser editing.

### Implementation
The layout uses a `contenteditable` div for input:
```html
<div class="richtext-editor">
    <div class="editor-column">
        <div class="editor-toolbar">
            <button>Clear</button>
            <button>Copy Markdown</button>
        </div>
        <div id="richtext-input" class="richtext-input" contenteditable="true"></div>
    </div>
    <div class="markdown-column">
        <div id="markdown-output" class="markdown-output"></div>
    </div>
</div>
```
JavaScript, in `/scripts/richtext-to-markdown.js`, handles conversion and toolbar actions:
```javascript
document.addEventListener('DOMContentLoaded', () => {
    const richtextInput = document.getElementById('richtext-input');
    const markdownOutput = document.getElementById('markdown-output');

    function htmlToMarkdown(html) {
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = html;
        
        function processNode(node) {
            if (node.nodeType === Node.TEXT_NODE) return node.textContent;
            let markdown = '';
            const tagName = node.tagName ? node.tagName.toLowerCase() : '';
            for (let child of node.childNodes) markdown += processNode(child);
            switch(tagName) {
                case 'strong': case 'b': return `**${markdown}**`;
                case 'em': case 'i': return `*${markdown}*`;
                case 'h1': return `# ${markdown}\n\n`;
                case 'ul': 
                    let ulContent = '';
                    node.querySelectorAll('li').forEach(li => ulContent += `- ${processNode(li).trim()}\n`);
                    return `${ulContent}\n`;
                case 'a':
                    const href = node.getAttribute('href');
                    if (href && href !== 'null' && href.trim() !== '') return `[${markdown}](${href})`;
                    return markdown;
                // More cases (h2-h6, ol, img, code, etc.)
                default: return markdown;
            }
        }
        
        let result = '';
        for (let child of tempDiv.childNodes) result += processNode(child);
        return result.replace(/\n{3,}/g, '\n\n').trim();
    }

    function clearContent() {
        richtextInput.innerHTML = '';
        markdownOutput.textContent = '';
    }

    function copyMarkdown() {
        const markdown = markdownOutput.textContent;
        if (markdown) navigator.clipboard.writeText(markdown).then(() => alert('Markdown copied to clipboard!'));
    }

    richtextInput.addEventListener('input', () => {
        markdownOutput.textContent = htmlToMarkdown(richtextInput.innerHTML);
    });

    richtextInput.addEventListener('paste', () => {
        setTimeout(() => markdownOutput.textContent = htmlToMarkdown(richtextInput.innerHTML), 10);
    });

    // Initialize with placeholder
    richtextInput.innerHTML = '<p>Paste your rich text here...</p>';
    markdownOutput.textContent = htmlToMarkdown(richtextInput.innerHTML);
});
```
The `htmlToMarkdown` function recursively processes HTML nodes, converting tags like `strong`, `ul`, and `a` into Markdown. The “Clear” button resets the input and output, while “Copy Markdown” uses the Clipboard API. The initial content (`<p>Paste your rich text here...</p>`) acts as a placeholder, cleared on user input.

### Challenges
- **HTML Parsing**: Recursive node processing handled complex HTML well, but required careful handling of edge cases (e.g., invalid `href` in links). I added checks to ensure robust conversion.
- **Placeholder Management**: The `contenteditable` div’s initial content was set via JavaScript, but clearing it on first input required user interaction or additional logic (planned for future UX improvements).
- **Paste Handling**: The 10ms delay on paste events ensured HTML was fully applied before conversion, but could be optimized for smoother performance.
- **Toolbar Simplicity**: The minimal toolbar improved UX but limited formatting options. Future enhancements could reintroduce formatting buttons if needed.

## Step 4: Polishing the Theme Toggle

The theme toggle evolved from a text button to a circular icon button with sun/moon SVGs:
```html
<button class="theme-toggle" onclick="toggleTheme()">
    <svg class="sun-icon" ...></svg>
    <svg class="moon-icon" ...></svg>
</button>
```
CSS controls icon visibility:
```css
.theme-toggle .sun-icon { display: none; }
.theme-toggle .moon-icon { display: block; }
[data-theme='dark'] .theme-toggle .sun-icon { display: block; }
[data-theme='dark'] .theme-toggle .moon-icon { display: none; }
```
The logic, in `/scripts/global.js`, uses `localStorage` for persistence, as shown earlier.

### Challenges
- **Icon Selection**: I chose Feather Icons for their clean, recognizable design.
- **Refactoring**: Moving theme logic to `/scripts/global.js` streamlined maintenance across `index.html`, `markdown-editor.html`, and `richtext-to-markdown.html`.

## Reflections and Future Plans

Building [brandgrand.rocks](https://brandgrand.rocks) taught me to balance design, functionality, and user experience. The site’s lightweight, responsive, and feature-rich, but there’s room for growth:

- **Optimization**: Minify CSS/JS, lazy-load images, and add a service worker for offline support.
- **Tool Enhancements**: Add syntax highlighting for the Markdown editor, a live preview for the rich text converter, or improved placeholder UX.
- **Accessibility**: Incorporate ARIA labels and keyboard navigation for tools and the theme toggle.
- **Refactoring**: Explore a static site generator for easier content management.

## Conclusion

Creating [brandgrand.rocks](https://brandgrand.rocks) was a journey of creativity and code. From the responsive homepage to the streamlined rich text converter, every piece reflects my passion for tech. Whether you’re here to explore my subdomains, join my communities, or try the tools, I hope you find inspiration. Visit the site, test the Markdown converter, and share your thoughts on [Discord](https://discord.brandgrand.link/main) or [Telegram](https://brandgrand.link/t/fossdump). Keep coding!


