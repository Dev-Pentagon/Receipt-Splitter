# Receipt Splitter

## Overview
Receipt Splitter is a mobile and web application that simplifies bill splitting among a group of people. Users can scan receipts, assign items to participants, and generate individual totals with an option to export the data.

## Features
- **Scan the receipt** using ML Kit text recognition
- **Add/Remove group participants** dynamically
- **Calculate the total price for each person** based on assigned items
- **Export data** showing the total amount owed by each participant
- **Offline-first** functionality for uninterrupted access
- **Cross-platform support** (Android, iOS, and Web)

## Screens
1. **Splash Screen** - Displays the app logo while loading
2. **Receipt List** - A list of scanned receipts with a FAB to create a new one
3. **Scan Receipt** - Uses ML Kit text recognition to extract text from the receipt
4. **Add Participants** - Allows users to add or remove participants
5. **Assign Items** - Links scanned items to participants
6. **Data Preview** - Displays a summary of assigned costs with an option to export

## Tech Stack
- **Framework:** Flutter 3.29.1
- **Language:** Dart 3.7.0
- **State Management:** Flutter BLOC
- **Storage:** SQFlite
- **Developer Tools:** DevTools 2.42.2

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/receipt-splitter.git
   cd receipt-splitter
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## Contribution
Contributions are welcome! Please submit an issue or pull request to contribute to the project.

## License
This project is licensed under the MIT License.

