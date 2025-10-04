# ShogunX 🥷

A Naruto-inspired mobile MMORPG built with Flutter, featuring ninja/fantasy themes and comprehensive RPG mechanics.

## 📱 About

ShogunX is a mobile MMORPG that brings the world of ninjas to your fingertips. Train your character, master powerful jutsus, complete missions, and rise through the ranks in this immersive ninja-themed adventure.

## ✨ Features

### Core Gameplay

- **Character Progression**: Train your ninja with various stats and abilities
- **Jutsu System**: Learn and master powerful ninja techniques
- **Mission System**: Complete missions to gain experience and rewards
- **Equipment & Inventory**: Collect and equip various ninja gear
- **Village Hub**: Explore different areas like training dojos, item shops, and more

### Game Areas

- **Training Dojo**: Improve your ninja skills
- **Mission Centre**: Accept and complete various missions
- **Item Shop**: Purchase equipment and consumables
- **Battle Grounds**: Test your skills against other players
- **Dueling Academy**: Practice combat techniques
- **Clan Hall**: Join and participate in clan activities
- **Hospital**: Restore health and recover from battles
- **Bank**: Manage your in-game currency

### Technical Features

- **State Management**: Built with Riverpod for efficient state management
- **Navigation**: Smooth routing with Go Router
- **Audio**: Immersive sound effects and background music
- **Theming**: Custom UI with Google Fonts integration
- **Data Persistence**: Local storage with SharedPreferences
- **Code Generation**: Automated models with Freezed and JSON serialization

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Navigation**: Go Router
- **Code Generation**: Freezed, JSON Serializable
- **Audio**: AudioPlayers
- **Fonts**: Google Fonts
- **Local Storage**: SharedPreferences

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android device/emulator or iOS simulator

### Installation

1. **Clone the repository**

   ```bash
   git clone <your-repo-url>
   cd shogunx
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code**

   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**

   **For Web (Port 3000):**

   ```bash
   flutter run -d edge --web-port 3000
   ```

   **For other platforms:**

   ```bash
   # List available devices
   flutter devices
   
   # Run on specific device
   flutter run -d <device-id>
   
   # Run on default device
   flutter run
   ```

   **Quick Start Scripts:**
   - Use `run_flutter_port_3000.bat` (Windows) to run on port 3000
   - Use `run_flutter.bat` (Windows) for default device
   - Use `start_flutter_clean.bat` (Windows) for clean build

## 📁 Project Structure

```text
lib/
├── app/                    # App configuration (router, theme)
├── constants/             # Game constants (villages, etc.)
├── controllers/           # State management providers
├── models/               # Data models with code generation
├── screens/              # UI screens organized by feature
│   ├── auth/            # Authentication screens
│   ├── home/            # Main game screens
│   ├── inventory/       # Inventory management
│   ├── map/             # Game world map
│   ├── profile/         # Player profile
│   └── village_hub/     # Village locations
├── utils/               # Utility functions
└── widgets/             # Reusable UI components
```

## 🎮 Game Mechanics

### Character Stats

- **Health**: Your ninja's vitality
- **Chakra**: Energy for using jutsus
- **Stamina**: Physical endurance
- **Strength**: Physical combat power
- **Speed**: Movement and reaction time
- **Intelligence**: Learning and jutsu mastery

### Progression System

- **Ranks**: Advance through ninja ranks
- **Equipment**: Gear that enhances your abilities
- **Jutsus**: Special techniques with unique effects
- **Missions**: Complete tasks for experience and rewards

## 🚀 Running the Application

### Web Development (Recommended for Development)

**Run on Port 3000:**

```bash
flutter run -d edge --web-port 3000
```

**Access the app:**

- Open your browser and go to: `http://localhost:3000`
- The app will automatically reload when you make changes (hot reload)

### Mobile Development

**Android:**

```bash
# Start Android emulator first, then:
flutter run -d android
```

**iOS (macOS only):**

```bash
# Start iOS simulator first, then:
flutter run -d ios
```

### Desktop Development

**Windows:**

```bash
flutter run -d windows
```

**macOS:**

```bash
flutter run -d macos
```

**Linux:**

```bash
flutter run -d linux
```

### Quick Start Scripts (Windows)

The project includes convenient batch files for Windows users:

- **`run_flutter_port_3000.bat`** - Simple script to run Flutter on port 3000
- **`run_flutter.bat`** - Advanced script that kills existing processes and runs on port 3000 with cleanup
- **`start_flutter_clean.bat`** - Comprehensive script that ensures port 3000 is free and runs Flutter cleanly

**Recommended for development:** Use `start_flutter_clean.bat` for the most reliable startup experience.

## 🔧 Development

### Code Generation

This project uses code generation for models. After making changes to `.dart` files with `@freezed` or `@JsonSerializable`, run:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Linting

The project uses Flutter Lints for code quality:

```bash
flutter analyze
```

### Testing

Run tests with:

```bash
flutter test
```

### Hot Reload

When running the app, you can use these commands:

- **`r`** - Hot reload (apply changes without restarting)
- **`R`** - Hot restart (restart the app)
- **`q`** - Quit the app

### Troubleshooting

**Port 3000 already in use:**

```bash
# Kill processes using port 3000 (Windows)
netstat -ano | findstr :3000
taskkill /f /pid <PID>

# Or use the clean start script
start_flutter_clean.bat
```

**Code generation errors:**

```bash
# Clean and regenerate code
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Flutter doctor issues:**

```bash
# Check Flutter setup
flutter doctor

# Fix common issues
flutter doctor --android-licenses
```

**Web-specific issues:**

- If images fail to load, check your internet connection (placeholder images are loaded from external sources)
- For CORS issues, ensure you're running from localhost
- Clear browser cache if you encounter caching issues

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the Naruto universe
- Built with Flutter and the amazing Flutter community
- Special thanks to all contributors and testers

---

**Ready to begin your ninja journey? Download ShogunX and become the ultimate shinobi!** 🥷✨
