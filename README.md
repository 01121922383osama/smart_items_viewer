# Smart Items Viewer

A Flutter application that displays a list of items with infinite scrolling, pull-to-refresh, and robust offline caching using the DummyJSON API.

## Features

- **Infinite Scrolling (Pagination)**: Automatically loads more items when scrolling near the end
- **Pull-to-Refresh**: Swipe down to refresh the list
- **Offline-First Caching**: Shows cached data instantly, then updates in the background
- **Stale-While-Revalidate**: Displays cached data while fetching fresh data
- **Clean Architecture**: Domain/Data/Presentation layers with proper separation of concerns
- **State Management**: Uses Cubit for predictable state management
- **Error Handling**: Comprehensive error handling with retry mechanisms
- **Internationalization**: Support for Arabic and English languages
- **Dark/Light Theme**: Material 3 design with theme switching
- **Shimmer Loading**: Beautiful loading animations
- **Network Resilience**: Handles connectivity issues gracefully

## Architecture

The app follows Clean Architecture principles:

```
lib/
├── core/
│   ├── error/           # Error handling (failures, exceptions)
│   ├── network/         # Network layer (Dio, connectivity)
│   ├── utils/           # Utility functions
│   └── di/              # Dependency injection
├── features/items/
│   ├── data/            # Data layer (DTOs, data sources, repository impl)
│   ├── domain/          # Domain layer (entities, repositories, use cases)
│   └── presentation/    # Presentation layer (Cubit, UI)
└── l10n/                # Localization
```

## Dependencies

- **State Management**: `flutter_bloc`
- **Functional Programming**: `dartz`, `equatable`
- **Dependency Injection**: `get_it`
- **HTTP Client**: `dio` with `pretty_dio_logger`
- **Local Storage**: `hive` with `hive_flutter`
- **Connectivity**: `connectivity_plus`
- **JSON Serialization**: `json_annotation` + `build_runner`
- **UI Components**: `shimmer`, `cached_network_image`
- **Internationalization**: `intl`

## Getting Started

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Generate code** (for JSON serialization):
   ```bash
   flutter packages pub run build_runner build
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## API Integration

The app integrates with the DummyJSON API:
- **Endpoint**: `https://dummyjson.com/products`
- **Pagination**: Uses `limit` and `skip` parameters
- **Response Format**: JSON with products array and metadata

## Caching Strategy

- **Cache TTL**: 10 minutes
- **Storage**: Hive database for local persistence
- **Strategy**: Stale-while-revalidate
- **Offline Support**: Shows cached data when offline

## State Management

The app uses a state machine with the following states:
- `isLoadingInitial`: Initial loading state
- `isLoadingMore`: Loading more items (pagination)
- `isRefreshing`: Pull-to-refresh state
- `isStale`: Indicates if data is cached and potentially outdated
- `hasNext`: Whether more items are available
- `failure`: Error state with retry capability

## UI/UX Features

- **Shimmer Loading**: Beautiful skeleton loading animations
- **Empty States**: User-friendly empty state messages
- **Error Handling**: Inline error messages with retry buttons
- **Pull-to-Refresh**: Native refresh indicator
- **Infinite Scroll**: Seamless pagination
- **Stale Indicator**: Shows when cached data is being displayed

## Localization

The app supports:
- **English** (en)
- **Arabic** (ar)

All UI text is localized and can be switched dynamically.

## Testing

The app includes comprehensive error handling and offline scenarios:
- Network failures
- Server errors
- Cache failures
- Connectivity issues
- Timeout handling

## Performance

- **Efficient Caching**: Only caches necessary data
- **Memory Management**: Proper disposal of resources
- **Network Optimization**: Request cancellation and retry logic
- **UI Performance**: Optimized list rendering with proper state management

## Future Enhancements

- Search functionality
- Filtering and sorting
- Item details page
- Favorites system
- Advanced caching strategies
- Unit and integration tests

## License

This project is for educational purposes and demonstrates Flutter best practices for building robust, offline-first applications.