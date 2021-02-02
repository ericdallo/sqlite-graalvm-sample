#!/usr/bin/env bash

set -e

if [[ ! -f "$SQLITE_GRAALVM_SAMPLE_JAR" ]]
then
    lein with-profiles +native-image "do" clean, uberjar
    SQLITE_GRAALVM_SAMPLE_JAR=$(ls target/sqlite-graalvm-sample-*-standalone.jar)
fi

SQLITE_GRAALVM_SAMPLE_XMX=${SQLITE_GRAALVM_SAMPLE_XMX:-"-J-Xmx4g"}

args=("-jar" "$SQLITE_GRAALVM_SAMPLE_JAR"
      "-H:Name=sqlite-graalvm-sample"
      "-J-Dclojure.compiler.direct-linking=true"
      "-J-Dclojure.spec.skip-macros=true"
      "-H:+ReportExceptionStackTraces"
      "--enable-url-protocols=jar"
      "-H:+InlineBeforeAnalysis"
      "-H:Log=registerResource:"
      "--verbose"
      "-H:IncludeResources=\"db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*|.*.properties\""
      "-H:ConfigurationFileDirectories=graalvm"
      "--initialize-at-build-time"
      "--report-unsupported-elements-at-runtime"
      "--no-server"
      "--no-fallback"
      "--native-image-info"
      "--allow-incomplete-classpath"
      "$SQLITE_GRAALVM_SAMPLE_XMX")

SQLITE_GRAALVM_SAMPLE_STATIC=${SQLITE_GRAALVM_SAMPLE_STATIC:-}

if [ "$SQLITE_GRAALVM_SAMPLE_STATIC" = "true" ]; then
    args+=("--static")
fi

native-image "${args[@]}"
