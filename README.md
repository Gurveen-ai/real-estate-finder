# EstateEase — Real Estate Finder (Flutter Web)

A responsive, exam-ready Flutter UI project for browsing real estate listings.

## Features
- Responsive desktop, tablet and mobile layouts
- Buy / Rent / Commercial purpose tabs
- Search by property name or Hyderabad locality
- Filter by property type
- Sort by recommended, price low-to-high and high-to-low
- Save/unsave properties with the heart button
- Property detail dialog and schedule-visit interaction
- Sample property cards and contact/help banner

## Run locally
1. Install Flutter SDK and enable web support:
   ```bash
   flutter config --enable-web
   ```
2. From this project folder:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
3. Build for web:
   ```bash
   flutter build web --release
   ```

## Deploy to GitHub Pages
1. Create a public GitHub repository and upload this project.
2. In `pubspec.yaml`, keep the project name as `real_estate_finder`.
3. Build with the repository path as base href:
   ```bash
   flutter build web --release --base-href /YOUR_REPOSITORY_NAME/
   ```
4. Publish the generated `build/web` folder using GitHub Pages. You can use the `gh-pages` branch or GitHub Actions.
5. Open the published URL in an incognito window and test it before submitting.

## Deploy to Vercel
1. Push the project to GitHub.
2. Import the repository in Vercel.
3. Set **Build Command** to:
   ```bash
   flutter build web --release
   ```
   If Vercel does not have Flutter preinstalled, use a Flutter-enabled build environment or deploy the generated `build/web` output.
4. Set **Output Directory** to `build/web`.

## Viva preparation
Be ready to explain:
- `MaterialApp` and `ThemeData` configure the app and design system.
- `StatefulWidget` is used because search, filters, sorting and favorites change the UI.
- `setState()` rebuilds widgets after a user interaction.
- `List<Property>` stores sample listing data; `visibleProperties` derives filtered/sorted results.
- `LayoutBuilder` and `MediaQuery` make the UI responsive.
- `Image.network` loads listing images from remote image URLs.
- `showDialog` displays property details; `SnackBar` gives feedback.

## Notes
- This is a front-end UI demo. Listings and prices are sample data; no backend, login, map API or real booking service is connected.
- Internet access is needed for remote property photos. A fallback placeholder is shown if an image fails.
