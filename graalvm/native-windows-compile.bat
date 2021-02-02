@echo off

dir

echo Building sqlite-graalvm-sample %SQLITE_GRAALVM_SAMPLE_JAR% with Xmx of %SQLITE_GRAALVM_SAMPLE_XMX%

Rem the --no-server option is not supported in GraalVM Windows.
call %GRAALVM_HOME%\bin\native-image.cmd ^
      "-jar" "%SQLITE_GRAALVM_SAMPLE_JAR%" ^
      "-H:Name=sqlite-graalvm-sample" ^
      "-J-Dclojure.compiler.direct-linking=true" ^
      "-J-Dclojure.spec.skip-macros=true" ^
      "-H:+ReportExceptionStackTraces" ^
      "--enable-url-protocols=jar" ^
      "-H:+InlineBeforeAnalysis" ^
      "-H:Log=registerResource:" ^
      "--verbose" ^
      "-H:IncludeResources='db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*|.*.properties'" ^
      "-H:ConfigurationFileDirectories=graalvm" ^
      "--initialize-at-build-time" ^
      "--report-unsupported-elements-at-runtime" ^
      "--no-fallback" ^
      "--native-image-info" ^
      "--allow-incomplete-classpath" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileReader" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileReader" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.MixerProvider" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.FormatConversionProvider" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileWriter" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiDeviceProvider" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.SoundbankReader" ^
      "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileWriter" ^
      "%SQLITE_GRAALVM_SAMPLE_XMX%")

if %errorlevel% neq 0 exit /b %errorlevel%

echo Creating zip archive
jar -cMf sqlite-graalvm-sample-native-windows-amd64.zip sqlite-graalvm-sample.exe
