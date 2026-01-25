// Core - Utilities and Constants
export 'core/api/api_client.dart';
export 'core/api/api_endpoints.dart';
export 'core/constants/app_constants.dart';
export 'core/errors/app_error.dart';
export 'core/errors/failure.dart';
export 'core/theme/app_theme.dart';
export 'core/utils/validators.dart';

// Domain - Models and Entities
export 'domain/models/battery_model.dart';
export 'domain/models/spare_part_model.dart';
export 'domain/models/sale_model.dart';
export 'domain/models/sale_item_model.dart';
export 'domain/enums/payment_type.dart';
export 'domain/enums/payment_status.dart';
export 'domain/enums/product_type.dart';

// Data - API Services
export 'data/services/auth_service.dart';
export 'data/services/battery_service.dart';
export 'data/services/spare_part_service.dart';
export 'data/services/sale_service.dart';
export 'data/services/image_service.dart';

// Presentation - Providers
export 'presentation/providers/auth_provider.dart';
export 'presentation/providers/battery_provider.dart';
export 'presentation/providers/spare_part_provider.dart';
export 'presentation/providers/sale_provider.dart';

// Presentation - Screens
export 'presentation/screens/auth/login_screen.dart';
export 'presentation/screens/auth/otp_screen.dart';
export 'presentation/screens/home/home_screen.dart';
export 'presentation/screens/battery/battery_list_screen.dart';
export 'presentation/screens/battery/battery_form_screen.dart';
export 'presentation/screens/spare_part/spare_part_list_screen.dart';
export 'presentation/screens/spare_part/spare_part_form_screen.dart';
export 'presentation/screens/sale/sale_screen.dart';
export 'presentation/screens/sale/sale_history_screen.dart';

// Presentation - Widgets
export 'presentation/widgets/custom_button.dart';
export 'presentation/widgets/custom_text_field.dart';
export 'presentation/widgets/error_widget.dart';
export 'presentation/widgets/loading_widget.dart';
export 'presentation/widgets/product_card.dart';
