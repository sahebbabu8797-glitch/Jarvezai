#!/bin/sh

APP_HOME=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
WRAPPER_JAR="$APP_HOME/gradle/wrapper/gradle-wrapper.jar"
JAVACMD=java
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/java" ]; then
  JAVACMD="$JAVA_HOME/bin/java"
fi

# Prefer an existing system Gradle on cloud builders.
# The project can also use the official Gradle Wrapper when gradle-wrapper.jar
# is present. We intentionally do not auto-download the wrapper here because
# restricted cloud builders may block GitHub/raw downloads.

if [ -f "$WRAPPER_JAR" ]; then
  exec "$JAVACMD" -classpath "$WRAPPER_JAR" org.gradle.wrapper.GradleWrapperMain "$@"
fi

if command -v gradle >/dev/null 2>&1; then
  exec gradle "$@"
fi

echo "Unable to obtain the Gradle Wrapper JAR. This project requires network access or a system Gradle installation." >&2
exit 1
