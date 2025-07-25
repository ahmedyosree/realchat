# realchat

RealChat
End-to-end encrypted chat app built with Flutter, Firebase, Bloc, Drift and sodium; uses elliptic curve Diffie–Hellman for key exchange and ChaCha20-Poly1305 for authenticated encryption.

Streams encrypted messages from Firestore in real time, decrypts and saves them to SQLite (Drift), then streams them from SQL to the UI via BLoC.

Features a search bar for finding friends and starting new chats, caching results locally to avoid redundant Firestore calls.

Designed with dependency injection and clean-code best practices in a layered architecture (Service → Repository → Bloc → Presentation), with full offline support.

Android_apk: https://github.com/ahmedyosree/realchat/releases/download/v1.0/app-release.apk 


web: https://realchat-89c04.web.app
