#!/usr/bin/env bash
# Builds dist/terminal-tab-switch.zip. Needs only a JDK 21+ (javac + jar) on PATH: no IDE, no Gradle.
# The IDE interface is compiled from stubs/ and is not packaged; the IDE provides the real one.
#   ./build.sh                 -> version "dev"
#   VERSION=1.2.0 ./build.sh   -> what CI does for tag v1.2.0
set -euo pipefail
cd "$(dirname "$0")"
VERSION="${VERSION:-dev}"
NAME=terminal-tab-switch
MODULE=local.terminalTabSwitch.frontend
PKG="build/pkg/$NAME"

rm -rf build dist
mkdir -p build/stubs build/classes build/main/META-INF "$PKG/lib/modules" dist

javac --release 21 -nowarn -d build/stubs $(find stubs -name '*.java')
javac --release 21 -nowarn -cp build/stubs -d build/classes $(find src -name '*.java')

# Main jar: plugin.xml with the version filled in.
sed "s/@VERSION@/$VERSION/" resources/main/META-INF/plugin.xml > build/main/META-INF/plugin.xml
jar --create --no-manifest --file "$PKG/lib/$NAME.jar" -C build/main .

# Content module jar: module descriptor + the class.
cp "resources/module/$MODULE.xml" build/classes/
jar --create --no-manifest --file "$PKG/lib/modules/$MODULE.jar" -C build/classes .

# Plugin zip layout the IDE expects: terminal-tab-switch/lib/*.jar, content modules in lib/modules/.
(cd build/pkg && jar --create --no-manifest --file "../../dist/$NAME.zip" "$NAME")
echo "Built dist/$NAME.zip (version $VERSION)"
