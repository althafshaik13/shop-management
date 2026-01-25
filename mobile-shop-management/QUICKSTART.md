# 🚀 Quick Start Guide

## Prerequisites Check

Before you begin, ensure you have:

- ✅ Flutter SDK installed (>=3.0.0)
- ✅ Android Studio or VS Code with Flutter plugin
- ✅ Android Emulator or physical device
- ✅ Backend server running at `http://localhost:8080`

Check Flutter installation:

```bash
flutter doctor
```

## 5-Minute Setup

### Step 1: Navigate to Project

```bash
cd e:\shop-management\mobile-shop-management
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

Expected output:

```
Running "flutter pub get" in mobile-shop-management...
Resolving dependencies...
Got dependencies!
```

### Step 3: Configure Backend URL

**For Android Emulator:**
The app is pre-configured to work with `localhost`. No changes needed!

**For Physical Device:**

1. Find your computer's IP address
2. Update `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'http://YOUR_IP:8080/api';
// Example: 'http://192.168.1.100:8080/api'
```

### Step 4: Run the App

```bash
flutter run
```

Or select device and run:

```bash
flutter devices
flutter run -d <device-id>
```

## First Time Usage

### 1. Login

- Open the app
- Enter one of the allowed phone numbers:
  - `9490022396`
  - `9030600667`
  - `9985090032`
  - `8247415115`
  - `9030703188`

### 2. OTP Verification

- Check backend console for OTP (or SMS if configured)
- Enter the 6-digit OTP
- Click "Verify OTP"

### 3. Explore Features

Once logged in, try:

#### Add a Battery

1. Tap "Batteries"
2. Tap the "+" button
3. Fill in details:
   - Name: Exide 150Ah
   - Model: EXD-150
   - Capacity: 150Ah
   - Voltage: 12V
   - Warranty: 48 months
   - Dealer Price: 8500
   - Customer Price: 10000
   - Quantity: 25
4. Optional: Upload an image
5. Tap "Add Battery"

#### Add a Spare Part

1. Tap "Spare Parts"
2. Tap the "+" button
3. Fill in details:
   - Name: Battery Terminal
   - Category: Terminals
   - Dealer Price: 50
   - Customer Price: 75
   - Quantity: 100
4. Tap "Add Spare Part"

#### Create a Sale

1. Tap "New Sale"
2. Tap "Add Item"
3. Select product type (Battery/Spare Part)
4. Select product from dropdown
5. Enter quantity
6. Tap "Add Item"
7. Repeat for more items
8. Enter customer details (optional)
9. Select payment type and status
10. Tap "Complete Sale"

#### View Sale History

1. Tap "Sale History"
2. View all sales with totals
3. Use filters for specific data:
   - Tap calendar icon for date range
   - Tap filter icon for product/payment filters
4. Expand sale cards to see details

## Common Commands

### Clean Build

```bash
flutter clean
flutter pub get
flutter run
```

### Check for Issues

```bash
flutter doctor
flutter analyze
```

### Hot Reload

While app is running, press `r` in terminal or IDE

### Hot Restart

While app is running, press `R` in terminal or IDE

### View Logs

```bash
flutter logs
```

## Troubleshooting

### Issue: "Unable to connect"

**Solution:**

- Verify backend is running: `http://localhost:8080`
- For Android Emulator: No change needed
- For physical device: Update IP in `app_constants.dart`
- Check firewall settings

### Issue: "Build failed"

**Solution:**

```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "No devices found"

**Solution:**

- Start Android Emulator: AVD Manager → Launch
- Or connect physical device with USB debugging enabled
- Run: `flutter devices` to verify

### Issue: "OTP not received"

**Solution:**

- Check backend console logs
- Backend may be logging OTP instead of sending SMS
- Use logged OTP for testing

### Issue: "Image upload fails"

**Solution:**

- Check backend storage directory exists
- Verify write permissions
- Check file size limits in backend config

## Development Tips

### 1. Hot Reload for Fast Development

After code changes, press `r` to hot reload (keeps app state)

### 2. Debug Mode

Run with debug mode for helpful error messages:

```bash
flutter run --debug
```

### 3. Performance Mode

For testing performance:

```bash
flutter run --profile
```

### 4. Check Widget Tree

In debug mode, tap on screen to see widget boundaries and info

### 5. Use DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## IDE Setup

### VS Code

1. Install Flutter extension
2. Press F5 to run and debug
3. Use breakpoints for debugging
4. View widget tree in Flutter Inspector

### Android Studio

1. Open project
2. Click Run button (green play icon)
3. Use Flutter Inspector tab
4. Set breakpoints for debugging

## Testing the App

### Manual Testing Checklist

#### Authentication

- [ ] Login with phone number
- [ ] Receive and verify OTP
- [ ] Auto-login on app restart
- [ ] Logout functionality

#### Battery Management

- [ ] View battery list
- [ ] Add new battery
- [ ] Upload battery image
- [ ] Edit existing battery
- [ ] Delete battery
- [ ] View battery details

#### Spare Part Management

- [ ] View spare parts list
- [ ] Add new spare part
- [ ] Upload spare part image
- [ ] Edit existing spare part
- [ ] Delete spare part

#### Sales

- [ ] Add items to sale
- [ ] Mix batteries and spare parts
- [ ] Enter customer details
- [ ] Select payment type/status
- [ ] Complete sale
- [ ] View total and profit

#### Sale History

- [ ] View all sales
- [ ] Filter by date range
- [ ] Filter by product type
- [ ] Filter by payment status
- [ ] View sale details
- [ ] See sales summary

## Build for Production

### Android APK

```bash
flutter build apk --release
```

Find APK at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Find bundle at: `build/app/outputs/bundle/release/app-release.aab`

### iOS (requires Mac)

```bash
flutter build ios --release
```

## Next Steps

### Customize Your App

1. **Update App Name**
   - Edit `pubspec.yaml`: Change `name:` field
   - Update `AndroidManifest.xml` for Android
   - Update `Info.plist` for iOS

2. **Change App Icon**
   - Use `flutter_launcher_icons` package
   - Add icon images to `assets/`
   - Run icon generator

3. **Update Theme**
   - Edit `lib/core/theme/app_theme.dart`
   - Change primary/secondary colors
   - Customize fonts

4. **Add Features**
   - Reports and analytics
   - Offline mode
   - Backup functionality
   - More product types
   - Advanced filters

### Deploy to Stores

#### Google Play Store

1. Create Play Console account
2. Prepare store listing
3. Upload app bundle
4. Complete release

#### Apple App Store

1. Create App Store Connect account
2. Prepare app listing
3. Archive and upload
4. Submit for review

## Support Resources

### Documentation

- [README.md](README.md) - Main documentation
- [SETUP.md](SETUP.md) - Detailed setup
- [API_REFERENCE.md](API_REFERENCE.md) - API docs
- [ARCHITECTURE.md](ARCHITECTURE.md) - Architecture diagrams

### Flutter Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Documentation](https://pub.dev/packages/provider)

### Get Help

- Check backend logs
- Check Flutter logs: `flutter logs`
- Review error messages carefully
- Search Stack Overflow
- Check GitHub issues

## Success! 🎉

Your app is now running! You have:

- ✅ Complete shop management system
- ✅ Clean architecture implementation
- ✅ Production-ready code
- ✅ Full CRUD operations
- ✅ Image upload support
- ✅ Sales tracking
- ✅ Error handling

**Happy coding!** 🚀

---

**Need help?** Check the documentation files or create an issue in the repository.
