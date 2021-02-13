@echo off

echo Building sqlite-graalvm-sample %SQLITE_GRAALVM_SAMPLE_JAR% with Xmx of %SQLITE_GRAALVM_SAMPLE_XMX%

rem the --no-server option is not supported in GraalVM Windows.
call %GRAALVM_HOME%\bin\native-image.cmd ^
      "-jar" "%SQLITE_GRAALVM_SAMPLE_JAR%" ^
      "-H:Name=sqlite-graalvm-sample" ^
      "-J-Dclojure.compiler.direct-linking=true" ^
      "-J-Dclojure.spec.skip-macros=true" ^
      "-H:+ReportExceptionStackTraces" ^
      "-H:+InlineBeforeAnalysis" ^
      "-H:Log=registerResource:" ^
      "--verbose" ^
      "-H:IncludeResources=db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*|.*.properties" ^
      "--initialize-at-build-time" ^
      "--report-unsupported-elements-at-runtime" ^
      "--no-fallback" ^
      "--allow-incomplete-classpath" ^
      "%SQLITE_GRAALVM_SAMPLE_XMX%"

if %errorlevel% neq 0 exit /b %errorlevel%

dir
rem graalvm ignores Name for some reason and use rem as the binary name
ren "rem.exe" "sqlite-graalvm-sample.exe"

dir
