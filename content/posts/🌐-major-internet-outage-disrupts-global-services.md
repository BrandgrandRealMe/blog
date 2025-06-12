---
title: 🌐 Major Internet Outage Disrupts Global Services
date: 2025-06-12T20:42:22.058Z
tags:
  - Internet Outage
  - Google Cloud
  - Cloudflare
  - Tech News
  - June 2025 Outage
  - Web Infrastructure
  - Cloud Services
  - Downtime
  - Service Disruption
  - IAM
  - Cloud Computing
  - Multi-Cloud
  - High Availability
  - Disaster Recovery
  - DevOps
  - Infrastructure Resilience
  - Status Monitoring
  - Spotify
  - Discord
  - Snapchat
  - Replit
  - Twitch
  - Google Workspace
  - Character AI
rsshide: false
description: A widespread internet outage on June 12, 2025, caused by a Google
  Cloud failure, disrupted major services like Spotify, Discord, Cloudflare, and
  more. This post breaks down what happened, who was affected, and why it
  matters.
---
Today, a massive outage rippled across the internet, knocking out access to some of the world’s most used platforms. The root cause? A serious disruption within **Google Cloud’s infrastructure**, which triggered a chain reaction that impacted **Cloudflare** and countless dependent apps and services.

---

## 🚨 What Happened?

At around **10:58 a.m. PDT / 1:58 p.m. EDT**, Google Cloud began experiencing service-wide issues. By **11:46 a.m. PDT**, reports began piling in across the tech world that everything from messaging apps to AI platforms had gone dark.

### 🧩 Key Points:

* **Google Cloud** suffered outages in services like:

  * Identity and Access Management (IAM)
  * Google Workspace (Gmail, Drive, Calendar, Meet)
  * BigQuery, Firestore, Vertex AI, and more
* **Cloudflare**, which relies on Google Cloud for some internal services, also reported disruptions to:

  * Authentication
  * WARP client
  * Access and Workers

Despite the impact, Cloudflare’s **core edge network remained stable**.

---

## 📉 Who Was Affected?

A huge range of platforms and services experienced outages, with DownDetector showing major spikes in user-reported issues:

| Service                | Peak Reports                                                                 |
| ---------------------- | ---------------------------------------------------------------------------- |
| **Spotify**            | 44,000+                                                                      |
| **Discord**            | 11,000+                                                                      |
| **Google Meet/Search** | 4,000+                                                                       |
| **Others**             | Snapchat, Twitch, Shopify, Character.AI, Replit, Cursor, Anthropic, and more |

Replit’s CEO confirmed on X (Twitter) that their downtime was caused by the Google Cloud outage and that their team was working directly with Google to bring things back online.

---

## 🛠️ Recovery Efforts

As of **12:12 p.m. PDT**, **Cloudflare** reported recovery was underway. **Google Cloud** also stated that partial restoration was in progress, though some U.S. central regions (notably `us-central1`) continued to face IAM issues that affected a broad swath of services.

Status dashboards across both platforms show that services are gradually returning to normal, but some may still face intermittent disruptions.

---

## 🧠 Why This Matters

This incident underscores the **interconnected fragility** of modern cloud infrastructure:

* A single cloud provider outage can take down dozens of downstream applications and services.
* Even global companies with massive engineering teams remain vulnerable if they lack multi-region or multi-cloud failover strategies.

---

## ✅ What Should You Do?

If you're a developer, business owner, or IT manager:

1. **Monitor status pages**: [Google Cloud](https://status.cloud.google.com/), [Cloudflare](https://www.cloudflarestatus.com/)
2. **Communicate proactively**: Let your users or customers know the issue is external and being addressed.
3. **Review your disaster recovery plan**: Consider whether your apps rely too heavily on a single cloud region or provider.
4. **Reassess single points of failure**: IAM and DNS systems should be designed with backup pathways.

---

## 🔮 What’s Next?

We expect a **detailed post-mortem** from Google Cloud in the coming days. It will likely highlight the root cause within their IAM system, recovery timelines, and what they’ll change to prevent a recurrence.

For now, services are mostly stabilizing, but today's events are a clear reminder: **even the most reliable cloud platforms can—and do—fail**.

---

🧵 **Stay tuned for updates. If your services are still down, check official status dashboards or social media for the latest.**

