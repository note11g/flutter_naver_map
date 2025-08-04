#!/bin/bash

# Flutter Naver Map - Convenient Test App Runner
# This script runs the Flutter app with convenient_test configuration

echo "🚀 Starting Flutter app with convenient_test..."
echo "📱 Available devices:"
flutter devices

# Automatically select the first available device
DEVICE_LINE=$(flutter devices | grep -E "^\s*[a-zA-Z].*•.*•.*•" | head -1)
FIRST_DEVICE=$(echo "$DEVICE_LINE" | sed 's/^[^•]*• \([^•]*\) •.*/\1/' | xargs)

# Determine platform and set host accordingly
if echo "$DEVICE_LINE" | grep -q "• ios"; then
  PLATFORM="iOS"
  HOST_IP="127.0.0.1"
else
  PLATFORM="Android"
  HOST_IP="10.0.2.2"
fi

echo ""
if [ -n "$FIRST_DEVICE" ]; then
  echo "🔧 Running app on device: $FIRST_DEVICE (Platform: $PLATFORM, Host: $HOST_IP)"
else
  echo "🔧 Running app on default device (Platform: $PLATFORM, Host: $HOST_IP)..."
fi
echo "⚠️  Note: If you want to use a specific device, run:"
echo "   flutter run integration_test/main_test.dart -d deviceId --host-vmservice-port 9753 --disable-service-auth-codes --dart-define \"CONVENIENT_TEST_APP_CODE_DIR=\$PWD\""
echo ""

# Function to open convenient_test_manager
open_convenient_test_manager() {
  local host_ip=$1
  echo "🎛️  Opening convenient_test_manager with host: $host_ip..."
  if [ -e "/Applications/convenient_test_manager.app" ]; then
    CONVENIENT_TEST_MANAGER_HOST="$host_ip" open -a /Applications/convenient_test_manager.app
    echo "✅ convenient_test_manager opened successfully"
  else
    echo "⚠️  convenient_test_manager.app not found at /Applications/"
    echo "   Please make sure convenient_test_manager is installed"
  fi
}

# Run the app with convenient_test configuration and monitor output
echo ""
echo "⏳ Starting app and monitoring for Dart VM Service availability..."

if [ -n "$FIRST_DEVICE" ]; then
  flutter run integration_test/main_test.dart \
    -d "$FIRST_DEVICE" \
    --host-vmservice-port 9753 \
    --disable-service-auth-codes \
    --dart-define "CONVENIENT_TEST_APP_CODE_DIR=$PWD" \
    --dart-define "CONVENIENT_TEST_HOST=$HOST_IP" \
    --dart-define "CONVENIENT_TEST_MANAGER_HOST=$HOST_IP" \
    2>&1 | while IFS= read -r line; do
      echo "$line"
      if echo "$line" | grep -q "A Dart VM Service.*is available at.*http://.*:9753"; then
        echo "✅ Dart VM Service detected!"
        open_convenient_test_manager "$HOST_IP"
      fi
    done
else
  flutter run integration_test/main_test.dart \
    --host-vmservice-port 9753 \
    --disable-service-auth-codes \
    --dart-define "CONVENIENT_TEST_APP_CODE_DIR=$PWD" \
    --dart-define "CONVENIENT_TEST_HOST=$HOST_IP" \
    --dart-define "CONVENIENT_TEST_MANAGER_HOST=$HOST_IP" \
    2>&1 | while IFS= read -r line; do
      echo "$line"
      if echo "$line" | grep -q "A Dart VM Service.*is available at.*http://.*:9753"; then
        echo "✅ Dart VM Service detected!"
        open_convenient_test_manager "$HOST_IP"
      fi
    done
fi