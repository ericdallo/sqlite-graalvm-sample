#!/usr/bin/env bash

set -e

if [ -z "$GRAALVM_HOME" ]; then
    echo "Please set GRAALVM_HOME"
    exit 1
fi

if [[ ! -f "$SQLITE_GRAALVM_SAMPLE_JAR" ]]
then
    lein with-profiles +native-image "do" clean, uberjar
    SQLITE_GRAALVM_SAMPLE_JAR=$(ls target/sqlite-graalvm-sample-*-standalone.jar)
fi

SQLITE_GRAALVM_SAMPLE_XMX=${SQLITE_GRAALVM_SAMPLE_XMX:-"-J-Xmx4g"}

"$GRAALVM_HOME/bin/gu" install native-image

args=("-jar" "$SQLITE_GRAALVM_SAMPLE_JAR"
      "-H:Name=sqlite-graalvm-sample"
      "-J-Dclojure.compiler.direct-linking=true"
      "-J-Dclojure.spec.skip-macros=true"
      "-H:+ReportExceptionStackTraces"
      "--enable-url-protocols=jar"
      "-H:+InlineBeforeAnalysis"
      "-H:Log=registerResource:"
      "--verbose"
      "-H:IncludeResources='db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*|.*.properties'"
      "-H:ConfigurationFileDirectories=graalvm"
      "--initialize-at-build-time"
      "--report-unsupported-elements-at-runtime"
      "--no-server"
      "--no-fallback"
      "--native-image-info"
      "--allow-incomplete-classpath"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileReader"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileReader"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.MixerProvider"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.FormatConversionProvider"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileWriter"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiDeviceProvider"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.SoundbankReader"
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileWriter"
      "$SQLITE_GRAALVM_SAMPLE_XMX")

"$GRAALVM_HOME/bin/native-image" "${args[@]}"
