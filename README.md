# ShogunX - Naruto-Inspired Mobile MMORPG

A Flutter-based mobile MMORPG with a ninja/fantasy theme, featuring turn-based combat, jutsu mastery, clan systems, and village exploration.

## Features

### Core Gameplay
- **5 Core Stats**: Strength, Intelligence, Speed, Defense, Willpower (max 250k)
- **4 Combat Stats**: Attack, Defense, Chakra, Stamina (max 500k)
- **Dual Element System**: With hybrid elements support
- **Jutsu Mastery**: 10 levels for normal jutsus, 15 for bloodline techniques
- **Turn-based Combat**: With equipped jutsu slots, CP/STA costs, and cooldowns

### App Features
- **Dark Theme**: Clean ninja/fantasy aesthetic with subtle textures
- **Bottom Navigation**: 5 main tabs (Home, Village Hub, Inventory, Map, Profile)
- **State Management**: Riverpod for reactive state management
- **Navigation**: Go Router with nested routes and shell routing
- **Typography**: Google Fonts with Orbitron for futuristic feel

## Project Structure

```
lib/
├── app/                    # App configuration
│   ├── theme.dart         # Dark theme with ninja aesthetics
│   └── router.dart        # Go Router configuration
├── models/                # Data models
│   ├── player.dart        # Player data model
│   ├── stats.dart         # Player statistics
│   ├── item.dart          # Item system with rarities
│   ├── jutsu.dart         # Jutsu system with types
│   ├── mission.dart       # Mission system with ranks
│   ├── clan.dart          # Clan management
│   ├── village.dart       # Village locations
│   ├── news.dart          # Game updates/news
│   └── chat.dart          # Chat system
├── controllers/           # State management
│   └── providers.dart     # Riverpod providers with dummy data
├── screens/               # UI screens
│   ├── home/              # Home screen with news & chat
│   ├── village_hub/       # Village facilities
│   │   ├── training_dojo_screen.dart
│   │   ├── item_shop_screen.dart
│   │   ├── hospital_screen.dart
│   │   ├── clan_hall_screen.dart
│   │   ├── bank_screen.dart
│   │   ├── battle_grounds_screen.dart
│   │   ├── mission_centre_screen.dart
│   │   └── dueling_academy_screen.dart
│   ├── inventory/         # Inventory management
│   │   ├── items_screen.dart
│   │   └── jutsus_screen.dart
│   ├── map/               # World map exploration
│   └── profile/           # Player profile & settings
└── widgets/               # Reusable UI components
    ├── main_shell.dart    # Bottom navigation shell
    ├── stat_bar.dart      # Progress bars for stats
    ├── info_card.dart     # Card components
    ├── timer_chip.dart    # Timer display widgets
    ├── currency_pill.dart # Currency display
    └── section_header.dart # Section headers
```

## Screens Overview

### 1. Home Screen
- **Game Updates**: News feed with pull-to-refresh
- **Chat System**: Global and Clan chat with tabbed interface
- **Player Overview**: Avatar, name, village, and Ryo balance

### 2. Village Hub
Grid of facility cards linking to specialized screens:
- **Training Dojo**: Train Attack, Defense, Chakra, Stamina with timers
- **Item Shop**: Purchase weapons, items, and consumables
- **Hospital**: Rest and use healing items
- **Clan Hall**: Join/manage clans, view members
- **Bank**: Deposit/withdraw Ryo
- **Battle Grounds**: Fight NPCs with different difficulty levels
- **Mission Centre**: Take on D-S rank missions with timers
- **Dueling Academy**: Challenge other players

### 3. Inventory
Tabbed interface for:
- **Items**: View, use, and manage inventory items
- **Jutsus**: Equip/unequip techniques, view stats

### 4. Map
- **Grid-based World**: 8x6 tile world map
- **Village Locations**: Special badges for villages (Leaf, Mist, Sand, etc.)
- **Movement System**: Tap adjacent tiles to move
- **Tile Information**: Details about current location

### 5. Profile
- **Player Stats**: HP, Chakra, Stamina, Attack, Defense, Speed
- **Equipment Summary**: Equipped jutsus and items
- **Settings**: Sound, notifications, theme preferences
- **Edit Profile**: Change name and avatar

## Technical Implementation

### State Management
- **Riverpod**: Reactive state management
- **Providers**: Separate providers for player, inventory, missions, chat, etc.
- **Dummy Data**: Fully populated with mock data for immediate testing

### Navigation
- **Go Router**: Declarative routing with nested routes
- **Shell Route**: Bottom navigation wrapper
- **Deep Linking**: Support for direct navigation to any screen

### UI Components
- **Reusable Widgets**: Modular components for consistency
- **Dark Theme**: Custom Material 3 theme with ninja aesthetics
- **Responsive Design**: Mobile-first approach
- **Animations**: Smooth transitions and loading states

### Data Models
- **Immutable Models**: All data models are immutable with copyWith methods
- **Type Safety**: Strong typing throughout the application
- **JSON Serialization**: Ready for backend integration

## Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.4.9    # State management
  go_router: ^12.1.3          # Navigation
  google_fonts: ^6.1.0        # Typography
  audioplayers: ^5.2.1        # Sound effects
```

## Getting Started

1. **Clone the repository**
2. **Install dependencies**: `flutter pub get`
3. **Run the app**: `flutter run`
4. **Build for release**: `flutter build apk --release`

## Features Ready for Backend Integration

- **Player Authentication**: Ready for user login/registration
- **Real-time Chat**: WebSocket integration points prepared
- **Mission System**: Timer-based missions ready for server sync
- **Clan Management**: Full clan system ready for multiplayer
- **Inventory Management**: Item and jutsu systems ready for persistence
- **Battle System**: Combat framework ready for server-side logic
- **Map Navigation**: Position tracking ready for multiplayer

## Future Enhancements

- **Real-time Multiplayer**: PvP battles and clan wars
- **Advanced Combat**: More complex battle mechanics
- **Guild System**: Extended clan features
- **Events**: Seasonal events and competitions
- **Achievements**: Progress tracking and rewards
- **Marketplace**: Player-to-player trading

## Development Notes

- **Clean Architecture**: Modular structure for easy maintenance
- **Mock Data**: Comprehensive dummy data for testing all features
- **Error Handling**: Graceful error handling throughout
- **Performance**: Optimized for smooth mobile experience
- **Accessibility**: Screen reader support and accessibility features

## Contributing

This project follows Flutter best practices and maintains a clean, documented codebase. All screens are fully functional with placeholder actions that can be easily replaced with real backend calls.

## License

This project is for educational and demonstration purposes.