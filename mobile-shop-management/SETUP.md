# Setup Guide - Mobile Shop Management

## Quick Setup

### 1. Backend Configuration

Before running the Flutter app, ensure your Spring Boot backend is running:

```bash
cd shop-management
./mvnw spring-boot:run
```

The backend should be accessible at `http://localhost:8080`

### 2. Flutter App Setup

Navigate to the Flutter project:

```bash
cd mobile-shop-management
```

Install dependencies:

```bash
flutter pub get
```

### 3. API Configuration

If your backend is running on a different URL, update [lib/core/constants/app_constants.dart](lib/core/constants/app_constants.dart):

```dart
static const String baseUrl = 'http://YOUR_IP:8080/api';
```

**Important for Android Emulator**: Use `http://10.0.2.2:8080/api` instead of `localhost`

**Important for Physical Device**: Use your computer's IP address, e.g., `http://192.168.1.100:8080/api`

### 4. Run the App

For debugging:

```bash
flutter run
```

For specific device:

```bash
flutter devices  # List available devices
flutter run -d <device-id>
```

### 5. Build for Production

Android APK:

```bash
flutter build apk --release
```

Android App Bundle:

```bash
flutter build appbundle --release
```

iOS (requires Mac):

```bash
flutter build ios --release
```

## Project Structure

```
mobile-shop-management/
├── lib/
│   ├── core/                    # Core utilities
│   │   ├── api/                # API client, endpoints
│   │   ├── constants/          # App constants
│   │   ├── errors/             # Error handling
│   │   ├── theme/              # App theme
│   │   └── utils/              # Validators
│   ├── data/                   # Data layer
│   │   └── services/           # API services
│   ├── domain/                 # Domain layer
│   │   ├── models/             # Data models
│   │   └── enums/              # Enumerations
│   ├── presentation/           # Presentation layer
│   │   ├── providers/          # State management
│   │   ├── screens/            # UI screens
│   │   └── widgets/            # Reusable widgets
│   ├── main.dart              # App entry point
│   └── exports.dart           # Barrel file
├── pubspec.yaml               # Dependencies
├── analysis_options.yaml      # Linter rules
└── README.md                  # Documentation
```

## Features Checklist

- ✅ **Authentication**
  - Phone-based OTP login
  - JWT token management
  - Auto-login

- ✅ **Battery Management**
  - Create, Read, Update, Delete
  - Image upload
  - Stock tracking

- ✅ **Spare Parts Management**
  - Full CRUD operations
  - Category support
  - Image upload

- ✅ **Sales**
  - Multi-item sales
  - Mixed product types
  - Profit calculation
  - Customer details
  - Payment tracking

- ✅ **Sale History**
  - Date range filtering
  - Product type filtering
  - Payment status filtering
  - Sales analytics

## Common Issues

### Issue: "Unable to connect to backend"

**Solution**:

- Check if backend is running
- Verify API base URL
- For Android Emulator, use `10.0.2.2` instead of `localhost`
- For physical device, ensure device and computer are on same network

### Issue: "Image upload fails"

**Solution**:

- Check backend storage directory configuration
- Verify file permissions
- Check file size limits

### Issue: "Build failed"

**Solution**:

```bash
flutter clean
flutter pub get
flutter run
```

## Testing Credentials

Use one of the allowed phone numbers configured in your backend:

- 9490022396
- 9030600667
- 9985090032
- 8247415115
- 9030703188

OTP will be sent/logged by the backend.

## Development Tips

1. **Hot Reload**: Press `r` in terminal while app is running
2. **Hot Restart**: Press `R` in terminal
3. **Debug Mode**: Use VS Code or Android Studio debugger
4. **Logs**: Check `flutter logs` for debugging

## API Endpoints Used

- `POST /api/auth/send-otp` - Send OTP
- `POST /api/auth/verify-otp` - Verify OTP
- `GET /api/batteries` - Get all batteries
- `POST /api/batteries` - Create battery
- `PUT /api/batteries/{id}` - Update battery
- `DELETE /api/batteries/{id}` - Delete battery
- `GET /api/spare-parts` - Get all spare parts
- `POST /api/spare-parts` - Create spare part
- `PUT /api/spare-parts/{id}` - Update spare part
- `DELETE /api/spare-parts/{id}` - Delete spare part
- `POST /api/sales` - Create sale
- `GET /api/sales` - Get sales with filters
- `POST /api/images/upload` - Upload image

## Next Steps

1. Test authentication flow
2. Add some batteries and spare parts
3. Create a test sale
4. View sale history
5. Customize theme and branding as needed

## Support

For issues or questions:

1. Check backend logs
2. Check Flutter logs: `flutter logs`
3. Verify network connectivity
4. Check API endpoint responses

Happy coding! 🚀
