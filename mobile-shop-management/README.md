# Mobile Shop Management

A production-ready Flutter application for managing shop inventory and sales with clean architecture.

## Features

- **Authentication**: Phone-based OTP authentication
- **Battery Management**: Full CRUD operations with image upload
- **Spare Parts Management**: Full CRUD operations with image upload
- **Sales Management**: Create sales with multiple items, track profit
- **Sale History**: View and filter sales with date ranges and filters
- **Image Upload**: Support for product images
- **State Management**: Provider pattern for reactive UI
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers

## Architecture

This project follows clean architecture principles:

```
lib/
├── core/                 # Core utilities
│   ├── api/             # API client and endpoints
│   ├── constants/       # App constants
│   ├── errors/          # Error handling
│   ├── theme/           # App theming
│   └── utils/           # Validators and utilities
├── data/                # Data layer
│   └── services/        # API services
├── domain/              # Domain layer
│   ├── models/          # Data models
│   └── enums/           # Enumerations
└── presentation/        # Presentation layer
    ├── providers/       # State management
    ├── screens/         # UI screens
    └── widgets/         # Reusable widgets
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Running backend server on http://localhost:8080

### Installation

1. Clone the repository
2. Navigate to the project directory:

   ```bash
   cd mobile-shop-management
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Update the API base URL in `lib/core/constants/app_constants.dart` if needed:

   ```dart
   static const String baseUrl = 'http://localhost:8080/api';
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## Configuration

### API Configuration

Update the base URL in `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'http://your-backend-url/api';
```

### Authentication

The app uses phone-based OTP authentication. Configure allowed phone numbers in your backend.

## Features Details

### Authentication

- Phone number validation
- OTP verification
- JWT token storage
- Auto-login on app restart

### Battery Management

- Add new batteries with details (name, model, capacity, voltage, warranty)
- Upload battery images
- Update existing batteries
- Delete batteries
- View battery stock levels

### Spare Parts Management

- Add spare parts with category
- Upload images
- Update and delete spare parts
- Track inventory

### Sales

- Create sales with multiple items
- Support both batteries and spare parts in same sale
- Calculate profit automatically
- Customer information (optional)
- Payment type (Cash/Online)
- Payment status tracking (Full Paid/Partial Paid/Unpaid)

### Sale History

- View all sales
- Filter by date range
- Filter by product type
- Filter by payment status
- View sales summary (total sales, revenue, profit)
- Expandable sale details

## Dependencies

Key dependencies used:

- `provider`: State management
- `dio`: HTTP client
- `shared_preferences`: Local storage
- `image_picker`: Image selection
- `cached_network_image`: Image caching
- `intl`: Date and number formatting
- `equatable`: Value equality
- `logger`: Logging

## Error Handling

The app includes comprehensive error handling:

- Network errors
- Server errors
- Authentication errors
- Validation errors
- User-friendly error messages

## Testing

Run tests:

```bash
flutter test
```

## Build

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For issues and questions, please create an issue in the repository.
