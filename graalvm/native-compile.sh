#!/usr/bin/env bash
set -e

lein with-profiles +native-image "do" clean, uberjar

native-image \
    -jar target/*-standalone.jar \
    -H:Name=sqlite-graalvm-sample \
    -J-Dclojure.compiler.direct-linking=true \
    -J-Dclojure.spec.skip-macros=true \
    -H:+ReportExceptionStackTraces \
    -H:+InlineBeforeAnalysis \
    -H:Log=registerResource: \
    --verbose \
    -H:IncludeResources="db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*|.*.properties" \
    -H:ConfigurationFileDirectories=graalvm \
    --initialize-at-build-time  \
    --report-unsupported-elements-at-runtime \
    --allow-incomplete-classpath \
    --no-server \
    --no-fallback
