#!/bin/bash
if [ "$CF_PAGES_BRANCH" == "main" ]; then
  git fetch --unshallow && npm install && hugo -b $BASE_URL --gc --minify --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo
else
  git fetch --unshallow && npm install && hugo -b $CF_PAGES_URL --gc --minify --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo
fi
