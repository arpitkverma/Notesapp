Flutter Firebase Notes App
A complete Flutter notes application with Firebase Authentication, secure Firestore CRUD operations, Provider state management, and modern UI features including note colors and offline support.

✨ Features
✅ Email/Password authentication (signup, login, logout with confirmation)

✅ Secure per-user notes (Firestore rules by user_id)

🔐 Real-time streaming updates across devices

🎨 Note colors with palette picker

📱 Clean, responsive UI (no overflow)

🌐 Offline-first with connectivity banner

🔍 Client-side search by title

📅 Formatted dates (created/updated)

✅ Delete confirmation dialogs

🛠 Tech Stack
text
• Flutter (mobile-first)
• Firebase Auth (email/password)
• Cloud Firestore (notes storage)
• Provider (state management)
• connectivity_plus (network status)
• intl (date formatting)

🚀 Quick Start

1. Clone & Setup
bash
git clone <your-repo-url>
cd notesapp
flutter pub get

3. Firebase Setup
text
1. Create Firebase project: https://console.firebase.google.com
2. Add Android app (com.example.notes_app)
3. Enable Email/Password in Authentication → Sign-in method
4. Enable Firestore Database (production mode)
5. Run: flutterfire configure
3. Firestore Rules & Index


Rules (firestore.rules):

javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /notes/{noteId} {
      allow read, update, delete: if request.auth != null && resource.data.user_id == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.user_id == request.auth.uid;
    }
  }
}

Composite Index (create via Firebase Console → Firestore → Indexes):

Deploy Rules & Run
bash
firebase deploy --only firestore:rules,firestore:indexes
flutter run

🔐 Authentication Flow
text
1. Email/Password signup → Creates Firebase Auth user
2. Session persists across app restarts (FirebaseAuth default)
3. Auto-navigates to notes if logged in
4. Logout confirmation dialog prevents accidents

🌐 Offline Support
Firestore persistence: Reads from cache, queues writes

Auth persistence: Stays logged in offline

Visual feedback: Red bottom banner "No internet connection"

Auto-sync: Changes sync when back online

🚀 Production Ready
text
✅ Secure (Firestore rules)
✅ Offline-first
✅ Real-time sync
✅ Responsive UI
✅ Error handling
✅ Loading states
✅ Professional UX
📱 Run on Device
