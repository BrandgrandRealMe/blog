#!/bin/bash
if [ "$CF_PAGES_BRANCH" == "main" ]; then
  git fetch --unshallow && hugo --gc --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo -b $CF_PAGES_URL
else
  git fetch --unshallow && hugo --gc --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo -b $CF_PAGES_URL
fi
