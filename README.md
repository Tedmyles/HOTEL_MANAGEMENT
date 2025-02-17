# HOTEL_MANAGEMENT & BOOKING APLICATION

The Hotel Management Application is a comprehensive app for managing hotel bookings, room inventory, and user interactions. This application is designed to facilitate seamless hotel operations, providing both users and hotel administrators with an intuitive platform for booking and managing rooms.

### Features

#### User Features:

1. **User Authentication:**
   - **Sign Up:** Users can create an account using their email and password.
   - **Login:** Users can sign in using their email and password.
   
2. **Room Booking:**
   - **Browse Rooms:** Users can view available rooms, their details, and prices.
   - **Book Rooms:** Users can book available rooms and receive confirmation.
   - **View Bookings:** Users can view their current and past bookings.

3. **User Profile:**
   - **View Profile:** Users can view their profile information.
   - **Edit Profile:** Users can update their profile information including password and profile photo.
4. **M-Pesa Integration:**
     The app has been integrated with mpesa to enable seamless and secure payment.

#### Admin Features:

1. **Room Management:**
   - **Add Room:** Admins can add new rooms to a hotel with details like room type, price, and availability.
   - **Edit Room:** Admins can update room details as needed.
   - **Delete Room:** Admins can remove rooms from the hotel.

2. **Booking Management:**
   - **View Bookings:** Admins can view all bookings made by users.
   - **Manage Bookings:** Admins can update booking statuses and handle cancellations.

3. **User Management:**
   - **View Users:** Admins can view all registered users.
   - **Manage Users:** Admins can update user information and handle user issues.

#### Additional Features:

1. **Notifications:**
   - Users receive notifications for booking confirmations and updates.
   - Admins receive notifications for new bookings and user inquiries.

2. **Reports and Analytics:**
   - Admins can generate reports on room bookings, revenue, and user activity.

### Implementation Details

#### Authentication:
- **Firebase Authentication:** Handles user sign-up and signin.
- **AuthProvider:** Manages authentication state and communicates with Firebase Authentication.

#### Room and Booking Management:
- **Firestore Database:** Stores data related to hotels, rooms, and bookings.
- **Room Model:** Defines the structure of room data.
- **Booking Model:** Defines the structure of booking data.

#### UI and Navigation:
- **Flutter:** The app is built using Flutter for cross-platform compatibility.
- **Provider:** Manages state throughout the app.
- **Navigation:** Utilizes Flutter's navigation system for routing between screens.

#### Security:
- **Password Hashing:** Handled internally by Firebase Authentication to ensure user passwords are securely stored.
- **Firestore Security Rules:** Enforce data access rules to ensure only authorized users can access or modify data.

#### Error Handling:
- **FirebaseAuthException:** Handles specific authentication errors and provides user-friendly error messages.
- **Firestore Exception Handling:** Ensures robust handling of Firestore operations.

![hotel_management & booking](https://github.com/Tedmyles/HOTEL_MANAGEMENT/assets/134784483/0e1f50e9-4296-43a8-9a0b-3829e1efe9d2)
