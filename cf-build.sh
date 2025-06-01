#!/bin/bash
if [ "$CF_PAGES_BRANCH" == "main" ]; then
  git fetch --unshallow && hugo -b $BASE_URL --gc --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo
else
  git fetch --unshallow && hugo -b $CF_PAGES_URL --gc --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo
fi
