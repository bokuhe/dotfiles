# SDKMAN (Software Development Kit Manager)
#
# Manages parallel installations of JVM SDKs (Java, Kotlin, Gradle, Maven, etc.).
# Only activates on machines where SDKMAN has been installed by the user.
# Install with: curl -s "https://get.sdkman.io?rcupdate=false" | bash
#
# The rcupdate=false flag is important — it prevents the installer from
# auto-appending init snippets to shell rc files, since we manage that here.

export SDKMAN_DIR="${SDKMAN_DIR:-$HOME/.sdkman}"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi
