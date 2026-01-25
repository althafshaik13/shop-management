# API Reference - Mobile Shop Management

## Base Configuration

```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'http://localhost:8080/api';
```

## Authentication

### Send OTP

```
POST /auth/send-otp?phone={phone}
```

**Request**

- Query Params: `phone` (string, 10 digits)

**Response**

- `200 OK`: String message
- `400 Bad Request`: Validation error

**Example**

```dart
final message = await authService.sendOtp('9490022396');
```

### Verify OTP

```
POST /auth/verify-otp?phone={phone}&otp={otp}
```

**Request**

- Query Params:
  - `phone` (string)
  - `otp` (string, 6 digits)

**Response**

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Example**

```dart
final token = await authService.verifyOtp('9490022396', '123456');
```

## Batteries

### Get All Batteries

```
GET /batteries
Authorization: Bearer {token}
```

**Response**

```json
[
  {
    "id": 1,
    "name": "Exide 150Ah",
    "modelNumber": "EXD-150",
    "capacity": "150Ah",
    "voltage": "12V",
    "warrantyPeriodInMonths": 48,
    "dealerPrice": 8500.0,
    "customerPrice": 10000.0,
    "quantity": 25,
    "imageUrl": "/images/batteries/abc123.jpg"
  }
]
```

### Get Battery by ID

```
GET /batteries/{id}
Authorization: Bearer {token}
```

### Create Battery

```
POST /batteries
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body**

```json
{
  "name": "Exide 150Ah",
  "modelNumber": "EXD-150",
  "capacity": "150Ah",
  "voltage": "12V",
  "warrantyPeriodInMonths": 48,
  "dealerPrice": 8500.0,
  "customerPrice": 10000.0,
  "quantity": 25,
  "imageUrl": "/images/batteries/abc123.jpg"
}
```

### Update Battery

```
PUT /batteries/{id}
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body**: Same as Create

### Delete Battery

```
DELETE /batteries/{id}
Authorization: Bearer {token}
```

**Response**: `204 No Content`

## Spare Parts

### Get All Spare Parts

```
GET /spare-parts
Authorization: Bearer {token}
```

**Response**

```json
[
  {
    "id": 1,
    "name": "Battery Terminal",
    "category": "Terminals",
    "dealerPrice": 50.0,
    "customerPrice": 75.0,
    "quantity": 100,
    "imageUrl": "/images/spare-parts/def456.jpg",
    "createdAt": "2026-01-15T10:30:00"
  }
]
```

### Get Spare Part by ID

```
GET /spare-parts/{id}
Authorization: Bearer {token}
```

### Create Spare Part

```
POST /spare-parts
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body**

```json
{
  "name": "Battery Terminal",
  "category": "Terminals",
  "dealerPrice": 50.0,
  "customerPrice": 75.0,
  "quantity": 100,
  "imageUrl": "/images/spare-parts/def456.jpg"
}
```

### Update Spare Part

```
PUT /spare-parts/{id}
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body**: Same as Create

### Delete Spare Part

```
DELETE /spare-parts/{id}
Authorization: Bearer {token}
```

**Response**: `204 No Content`

## Sales

### Create Sale

```
POST /sales
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body**

```json
{
  "items": [
    {
      "productType": "BATTERY",
      "productId": 1,
      "quantity": 2,
      "dealerPrice": 8500.0,
      "customerPrice": 10000.0
    },
    {
      "productType": "SPARE_PART",
      "productId": 5,
      "quantity": 4,
      "dealerPrice": 50.0,
      "customerPrice": 75.0
    }
  ],
  "paymentType": "CASH",
  "paymentStatus": "FULL_PAID",
  "customerName": "John Doe",
  "customerPhone": "9876543210",
  "customerAddress": "123 Main St"
}
```

**Response**

```json
{
  "id": 1,
  "saleDate": "2026-01-21T14:30:00",
  "totalAmount": 20300.00,
  "items": [...]
}
```

### Get Sales with Filters

```
GET /sales?startDate={date}&endDate={date}&productType={type}&paymentStatus={status}
Authorization: Bearer {token}
```

**Query Parameters** (all optional)

- `startDate`: ISO date (YYYY-MM-DD)
- `endDate`: ISO date (YYYY-MM-DD)
- `productType`: BATTERY | SPARE_PART
- `paymentStatus`: FULL_PAID | PARTIAL_PAID | UNPAID

**Response**: Array of sale objects

## Images

### Upload Image

```
POST /images/upload
Authorization: Bearer {token}
Content-Type: multipart/form-data
```

**Request**

- Form Data:
  - `file`: Image file (JPG, JPEG, PNG)
  - `folderType`: "batteries" | "spare-parts"

**Response**

```json
{
  "imageUrl": "/images/batteries/abc123.jpg"
}
```

**Example**

```dart
final imageUrl = await imageService.uploadImage(
  '/path/to/image.jpg',
  'batteries',
);
```

## Enums

### ProductType

- `SPARE_PART`
- `BATTERY`

### PaymentType

- `CASH`
- `ONLINE`

### PaymentStatus

- `FULL_PAID`
- `PARTIAL_PAID`
- `UNPAID`

## Error Responses

### 400 Bad Request

```json
{
  "message": "Validation error",
  "errors": {
    "name": "Name is required",
    "quantity": "Quantity must be positive"
  }
}
```

### 401 Unauthorized

```json
{
  "message": "Invalid or expired token"
}
```

### 404 Not Found

```json
{
  "message": "Battery not found with id: 123"
}
```

### 500 Internal Server Error

```json
{
  "message": "Internal server error occurred"
}
```

## Flutter Usage Examples

### Authentication Flow

```dart
// Send OTP
await context.read<AuthProvider>().sendOtp('9490022396');

// Verify OTP
final success = await context.read<AuthProvider>().verifyOtp(
  '9490022396',
  '123456',
);
```

### Battery Operations

```dart
// Load batteries
await context.read<BatteryProvider>().loadBatteries();

// Create battery
final battery = BatteryModel(
  name: 'Exide 150Ah',
  modelNumber: 'EXD-150',
  // ... other fields
);
await context.read<BatteryProvider>().createBattery(battery);

// Update battery
await context.read<BatteryProvider>().updateBattery(id, battery);

// Delete battery
await context.read<BatteryProvider>().deleteBattery(id);
```

### Sale Operations

```dart
// Add items to sale
final item = SaleItemModel(
  productType: ProductType.BATTERY,
  productId: 1,
  quantity: 2,
  dealerPrice: 8500,
  customerPrice: 10000,
);
context.read<SaleProvider>().addSaleItem(item);

// Complete sale
await context.read<SaleProvider>().createSale(
  paymentType: PaymentType.CASH,
  paymentStatus: PaymentStatus.FULL_PAID,
  customerName: 'John Doe',
  customerPhone: '9876543210',
);

// Load sales with filters
await context.read<SaleProvider>().loadSales(
  startDate: DateTime(2026, 1, 1),
  endDate: DateTime.now(),
  productType: ProductType.BATTERY,
  paymentStatus: PaymentStatus.FULL_PAID,
);
```

### Image Upload

```dart
// Pick and upload image
final XFile? image = await ImagePicker().pickImage(
  source: ImageSource.gallery,
);

if (image != null) {
  final imageUrl = await context.read<BatteryProvider>().uploadImage(
    image.path,
  );
}
```

## Testing with Postman/cURL

### Example cURL Commands

**Send OTP**

```bash
curl -X POST "http://localhost:8080/api/auth/send-otp?phone=9490022396"
```

**Verify OTP**

```bash
curl -X POST "http://localhost:8080/api/auth/verify-otp?phone=9490022396&otp=123456"
```

**Get Batteries**

```bash
curl -X GET "http://localhost:8080/api/batteries" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Create Battery**

```bash
curl -X POST "http://localhost:8080/api/batteries" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Exide 150Ah",
    "modelNumber": "EXD-150",
    "capacity": "150Ah",
    "voltage": "12V",
    "warrantyPeriodInMonths": 48,
    "dealerPrice": 8500.00,
    "customerPrice": 10000.00,
    "quantity": 25
  }'
```

## Rate Limiting

Currently no rate limiting is implemented. Consider adding rate limiting in production.

## API Versioning

Current version: v1 (implicit in base path `/api/`)

For future versions, consider:

- `/api/v2/batteries`
- Header-based versioning

## Best Practices

1. **Always include Authorization header** (except auth endpoints)
2. **Handle 401 responses** - Redirect to login
3. **Validate data client-side** before sending
4. **Use proper content types**
5. **Handle network errors gracefully**
6. **Implement retry logic** for transient failures
7. **Cache responses** where appropriate
8. **Use optimistic updates** for better UX

---

For issues or questions, refer to the backend API documentation or create an issue in the repository.
