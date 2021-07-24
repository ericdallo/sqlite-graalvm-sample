#!/usr/bin/env bash

set -e

if [ -z "$GRAALVM_HOME" ]; then
    echo "Please set GRAALVM_HOME"
    exit 1
fi

if [[ ! -f "$SQLITE_GRAALVM_SAMPLE_JAR" ]]
then
    lein "do" clean, uberjar
    SQLITE_GRAALVM_SAMPLE_JAR=$(ls target/sqlite-graalvm-sample-*-standalone.jar)
fi

SQLITE_GRAALVM_SAMPLE_XMX=${SQLITE_GRAALVM_SAMPLE_XMX:-"-J-Xmx4g"}

args=("-jar" "$SQLITE_GRAALVM_SAMPLE_JAR"
      "-H:+ReportExceptionStackTraces"
      "--verbose"
      "--no-fallback"
      "--native-image-info"
      "$SQLITE_GRAALVM_SAMPLE_XMX")

SQLITE_GRAALVM_SAMPLE_STATIC=${SQLITE_GRAALVM_SAMPLE_STATIC:-}

if [ "$SQLITE_GRAALVM_SAMPLE_STATIC" = "true" ]; then
    args+=("--static")
fi

"$GRAALVM_HOME/bin/native-image" "${args[@]}"
