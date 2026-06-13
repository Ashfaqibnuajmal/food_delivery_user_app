# Food Delivery User App

A Flutter-based food ordering application developed for **Ammavande Chayakada**, a family-run hotel business. The application allows customers to browse food items, manage favorites, place orders, make payments, interact with an AI food assistant, and track their orders through a modern mobile experience.

## Overview

This application was built to simplify food ordering and improve customer experience. Users can browse available food items, add products to their cart, manage delivery addresses, make online payments, and communicate with the hotel through an integrated system.

The application is connected to a Flutter Web admin dashboard where hotel staff can manage orders, food items, notifications, expenses, and customer interactions.

## Features

### Authentication

* Email & Password Login
* User Registration
* Forgot Password
* Google Sign-In
* Secure Authentication using Firebase

### Home

* Browse food categories
* View available food items
* Search functionality
* Food details page
* Dynamic content from Firestore

### Favorites

* Add food items to favorites
* Remove items from favorites
* Quick access to preferred foods

### Cart & Checkout

* Add items to cart
* Update item quantity
* Remove items from cart
* Delivery address management
* Location selection using Geolocator
* Order summary and confirmation

### Payments

* Razorpay Online Payments
* Cash On Delivery (COD)
* Secure order processing

### AI Food Assistant

* Food-related chatbot
* Interactive customer assistance
* Instant food suggestions and responses

### Profile

* User profile management
* Order history
* Settings
* Logout functionality

### Notifications

* Receive updates from hotel admin
* View announcements and offers

## Tech Stack

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Cloudinary
* Razorpay
* Geolocator
* BLoC State Management

## Architecture

This project follows a Feature-Based Folder Structure for better scalability and maintainability.

### State Management

* BLoC

### Backend Services

* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Cloudinary

## Screenshots

### Splash Screen

(Add Screenshot Here)

### Login Screen

(Add Screenshot Here)

### Home Screen

(Add Screenshot Here)

### Food Details

(Add Screenshot Here)

### Favorites

(Add Screenshot Here)

### Cart

(Add Screenshot Here)

### Checkout

(Add Screenshot Here)

### AI Food Assistant

(Add Screenshot Here)

### Profile

(Add Screenshot Here)

### Order History

(Add Screenshot Here)

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/food_delivery_user_app.git

cd food_delivery_user_app

flutter pub get

flutter run
```

## Project Structure

```text
lib/
├── core/
├── features/
│   ├── auth/
│   ├── home/
│   ├── favorites/
│   ├── cart/
│   ├── checkout/
│   ├── chatbot/
│   ├── profile/
│   └── orders/
├── services/
└── main.dart
```

## Future Improvements

* Real-time order tracking
* Push notifications
* Advanced AI assistant features
* Loyalty and rewards system
* Multi-language support

## Author

Ashfaq KV

Flutter Developer

GitHub: https://github.com/YOUR_USERNAME
