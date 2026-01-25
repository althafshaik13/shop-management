# Architecture Diagram

## High-Level Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                         MOBILE APP                              │
│                    (Flutter - Dart)                            │
└────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP/REST
                              │ JSON
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                      BACKEND API                               │
│                 (Spring Boot - Java)                           │
└────────────────────────────────────────────────────────────────┘
                              │
                              │ JPA/Hibernate
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                       DATABASE                                 │
│                    (PostgreSQL)                                │
└────────────────────────────────────────────────────────────────┘
```

## Flutter App - Clean Architecture Layers

```
┌──────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                          │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐   │
│  │   Screens      │  │    Widgets     │  │   Providers    │   │
│  │                │  │                │  │  (State Mgmt)  │   │
│  │  - Login       │  │  - Buttons     │  │  - Auth        │   │
│  │  - Battery     │  │  - TextFields  │  │  - Battery     │   │
│  │  - SparePart   │  │  - Cards       │  │  - SparePart   │   │
│  │  - Sale        │  │  - Loading     │  │  - Sale        │   │
│  │  - History     │  │  - Error       │  │                │   │
│  └────────────────┘  └────────────────┘  └────────────────┘   │
│                              │                                   │
│                              │ Uses Models & Calls Services     │
└──────────────────────────────┼──────────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────┐
│                         DOMAIN LAYER                             │
│  ┌────────────────────────┐  ┌────────────────────────┐        │
│  │       Models           │  │        Enums           │        │
│  │                        │  │                        │        │
│  │  - BatteryModel        │  │  - ProductType         │        │
│  │  - SparePartModel      │  │  - PaymentType         │        │
│  │  - SaleModel           │  │  - PaymentStatus       │        │
│  │  - SaleItemModel       │  │                        │        │
│  │                        │  │                        │        │
│  │  • fromJson()          │  │  • displayName         │        │
│  │  • toJson()            │  │  • values              │        │
│  │  • copyWith()          │  │                        │        │
│  └────────────────────────┘  └────────────────────────┘        │
│                              │                                   │
│                              │ Pure Dart objects                │
└──────────────────────────────┼──────────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────┐
│                          DATA LAYER                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    API Services                           │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐         │  │
│  │  │   Auth     │  │  Battery   │  │ SparePart  │         │  │
│  │  │  Service   │  │  Service   │  │  Service   │         │  │
│  │  └────────────┘  └────────────┘  └────────────┘         │  │
│  │  ┌────────────┐  ┌────────────┐                         │  │
│  │  │   Sale     │  │   Image    │                         │  │
│  │  │  Service   │  │  Service   │                         │  │
│  │  └────────────┘  └────────────┘                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                   │
│                              │ Uses ApiClient                   │
└──────────────────────────────┼──────────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────────┐
│                          CORE LAYER                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      ApiClient (Dio)                      │  │
│  │  • Interceptors (Auth Token Injection)                   │  │
│  │  • Error Handling                                        │  │
│  │  • Logging                                               │  │
│  │  • Timeout Configuration                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐              │
│  │ Constants  │  │   Errors   │  │   Theme    │              │
│  └────────────┘  └────────────┘  └────────────┘              │
│  ┌────────────┐  ┌────────────┐                              │
│  │ Validators │  │ Endpoints  │                              │
│  └────────────┘  └────────────┘                              │
└──────────────────────────────────────────────────────────────────┘
```

## Data Flow - Example: Loading Batteries

```
┌──────────────┐
│   User       │
│   Action     │  Tap "Batteries"
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────────┐
│  BatteryListScreen (UI)              │
│  - initState()                       │
└──────┬───────────────────────────────┘
       │ context.read<BatteryProvider>()
       │         .loadBatteries()
       ▼
┌──────────────────────────────────────┐
│  BatteryProvider (State Management)  │
│  - setState(loading)                 │
│  - Call service                      │
│  - Update state with data            │
│  - notifyListeners()                 │
└──────┬───────────────────────────────┘
       │ await _batteryService
       │       .getAllBatteries()
       ▼
┌──────────────────────────────────────┐
│  BatteryService (Data Layer)         │
│  - Calls API                         │
│  - Maps response to models           │
└──────┬───────────────────────────────┘
       │ _apiClient.get('/batteries')
       ▼
┌──────────────────────────────────────┐
│  ApiClient (HTTP Client)             │
│  - Add Authorization header          │
│  - Make HTTP request                 │
│  - Handle errors                     │
│  - Log request/response              │
└──────┬───────────────────────────────┘
       │ HTTP GET
       ▼
┌──────────────────────────────────────┐
│  Backend API                         │
│  GET /api/batteries                  │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│  JSON Response                       │
│  [{ id, name, price, ... }]          │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│  BatteryModel.fromJson()             │
│  Parse to Dart objects               │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│  BatteryProvider                     │
│  - batteries = parsed data           │
│  - state = success                   │
│  - notifyListeners()                 │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│  BatteryListScreen                   │
│  - UI rebuilds                       │
│  - Display battery list              │
└──────────────────────────────────────┘
```

## State Management Flow (Provider Pattern)

```
┌────────────────────────────────────────────────────────────┐
│                      Provider Tree                         │
│                                                            │
│  MultiProvider                                             │
│    ├── AuthProvider                                        │
│    ├── BatteryProvider                                     │
│    ├── SparePartProvider                                   │
│    └── SaleProvider                                        │
│                                                            │
└────────────────────────────────────────────────────────────┘
                              │
                              │ Provides to
                              ▼
┌────────────────────────────────────────────────────────────┐
│                      Widget Tree                           │
│                                                            │
│  MaterialApp                                               │
│    └── Consumer<AuthProvider>                              │
│          ├── LoginScreen (if not authenticated)            │
│          └── HomeScreen (if authenticated)                 │
│                └── BatteryListScreen                       │
│                      └── Consumer<BatteryProvider>         │
│                            └── ListView                    │
│                                  └── ProductCard           │
└────────────────────────────────────────────────────────────┘

When state changes:
1. Provider calls notifyListeners()
2. Consumer widgets rebuild automatically
3. UI updates reactively
```

## Authentication Flow

```
┌────────────┐
│   User     │
│   Opens    │
│    App     │
└─────┬──────┘
      │
      ▼
┌───────────────────────────────────┐
│  main.dart                        │
│  - Initialize SharedPreferences   │
│  - Initialize ApiClient           │
│  - Initialize Services            │
│  - Setup Providers                │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  AuthProvider                     │
│  - Check for saved token          │
│  - _checkAuthStatus()             │
└─────┬─────────────────────────────┘
      │
      ├─── Token Found ───┐
      │                   ▼
      │            ┌────────────────┐
      │            │  HomeScreen    │
      │            └────────────────┘
      │
      └─── No Token ─────┐
                         ▼
                  ┌────────────────┐
                  │  LoginScreen   │
                  │  - Enter phone │
                  └────────┬───────┘
                           │ Send OTP
                           ▼
                  ┌────────────────┐
                  │  OtpScreen     │
                  │  - Enter OTP   │
                  └────────┬───────┘
                           │ Verify
                           ▼
                  ┌────────────────┐
                  │  Save Token    │
                  │  to Prefs      │
                  └────────┬───────┘
                           │
                           ▼
                  ┌────────────────┐
                  │  HomeScreen    │
                  └────────────────┘
```

## Image Upload Flow

```
┌────────────┐
│   User     │
│   Taps     │
│   Camera   │
└─────┬──────┘
      │
      ▼
┌───────────────────────────────────┐
│  ImagePicker                      │
│  - Pick from gallery              │
│  - Returns XFile                  │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  BatteryProvider                  │
│  - uploadImage(path)              │
│  - Set uploading state            │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  ImageService                     │
│  - Create FormData                │
│  - Call API                       │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  ApiClient                        │
│  - Upload multipart/form-data     │
│  - POST /images/upload            │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  Backend                          │
│  - Save to filesystem             │
│  - Return image URL               │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  BatteryProvider                  │
│  - Update imageUrl                │
│  - Clear uploading state          │
│  - notifyListeners()              │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  UI                               │
│  - Display uploaded image         │
└───────────────────────────────────┘
```

## Sale Creation Flow

```
┌────────────┐
│   User     │
│   Adds     │
│   Items    │
└─────┬──────┘
      │
      ▼
┌───────────────────────────────────┐
│  SaleProvider                     │
│  - currentSaleItems []            │
│  - addSaleItem()                  │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  Calculate Totals                 │
│  - Sum item prices                │
│  - Calculate profit               │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  User Completes Sale              │
│  - Enter payment info             │
│  - Optional customer details      │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  SaleProvider.createSale()        │
│  - Build SaleModel                │
│  - Call service                   │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  SaleService                      │
│  - POST /sales                    │
│  - Send JSON payload              │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  Backend                          │
│  - Validate sale                  │
│  - Update inventory               │
│  - Save to database               │
│  - Return saved sale              │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  SaleProvider                     │
│  - Add to sales list              │
│  - Clear current items            │
│  - Show success message           │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  Navigate to Home                 │
└───────────────────────────────────┘
```

## Error Handling Architecture

```
┌───────────────────────────────────┐
│  API Call                         │
└─────┬─────────────────────────────┘
      │
      ▼
┌───────────────────────────────────┐
│  Try-Catch Block                  │
└─────┬─────────────────────────────┘
      │
      ├─── Success ───┐
      │               ▼
      │        ┌────────────┐
      │        │ Return     │
      │        │ Data       │
      │        └────────────┘
      │
      └─── Error ─────┐
                      ▼
             ┌──────────────────────┐
             │  DioException?       │
             └─────┬────────────────┘
                   │
                   ├─── Network Error
                   │         ▼
                   │    AppError(networkError)
                   │
                   ├─── Timeout
                   │         ▼
                   │    AppError(networkError)
                   │
                   ├─── 401
                   │         ▼
                   │    AppError(authError)
                   │
                   ├─── 404
                   │         ▼
                   │    AppError(notFound)
                   │
                   └─── 5xx
                            ▼
                       AppError(serverError)
                            │
                            ▼
             ┌──────────────────────┐
             │  Provider            │
             │  - Catch AppError    │
             │  - Set error state   │
             │  - notifyListeners() │
             └─────┬────────────────┘
                   │
                   ▼
             ┌──────────────────────┐
             │  UI                  │
             │  - Display error     │
             │  - Show retry button │
             └──────────────────────┘
```

---

This architecture ensures:

- ✅ **Separation of Concerns**
- ✅ **Testability**
- ✅ **Maintainability**
- ✅ **Scalability**
- ✅ **Clean Code**
