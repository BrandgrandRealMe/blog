#!/bin/bash
if [ "$CF_PAGES_BRANCH" == "main" ]; then
  BASE_OPT=""
  [ -n "$BASE_URL" ] && BASE_OPT="-b $BASE_URL"
  git fetch --unshallow && hugo $BASE_OPT --gc --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo
else
  BASE_OPT=""
  [ -n "$CF_PAGES_URL" ] && BASE_OPT="-b $CF_PAGES_URL"
  git fetch --unshallow && hugo $BASE_OPT --gc --templateMetrics --templateMetricsHints --forceSyncStatic --enableGitInfo
fi