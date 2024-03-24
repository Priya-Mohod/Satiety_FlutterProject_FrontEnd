class StringConstants {
  // -- Routes
  static String Home = '/HomeScreen';
  static String RootScreen = '/RootScreen';
  static String Dashboard = '/ListViewPage';
  static String Login = '/Login';
  static String Register = '/Register';
  static String OTPValidation = '/ValidateOTP';
  static String Forum = '/ForumPage';
  static String MyListings = '/myList';
  static String MyRequests = '/myRequests';
  static String Profile = '/Profile';
  static String PublicProfile = '/PublicProfile';
  static String AdsPage = '/AdsPage';
  static String Notifications = '/ForumPage';
  static String UsersNearMe = '/ForumPage';
  static String HelpCenter = '/ForumPage';
  static String MessagePage = '/MessegePage';
  static String SupplierLocationMap = '/SupplierLocationMap';

  // -- Page Titles
  static String Dashboard_title = 'Home';
  static String Login_title = 'Login';
  static String Register_title = 'Register';
  static String OTPValidation_title = 'OTP Validation';
  static String Forum_title = 'Forum';
  static String MyListings_title = 'My Listings';
  static String MyRequests_title = 'My Requests';
  static String AddFood_title = 'Add Food';
  static String Profile_title = 'Profile';
  static String Messages_title = 'Messages';
  static String MyChats_title = 'MyChats';
  static String Notifications_title = 'Notifications';
  static String UsersNearMe_title = 'Users Near Me';
  static String HelpCenter_title = 'Help Center';

  // -- General
  static String exception_error = 'Error connecting server, please try again';
  static String internet_error = 'Please check your internet connection!';
  static String server_error = 'Error connecting server, please try again';
  static String success = 'Succes';
  static String location_update = 'Updating your location...';
  static String location_update_error =
      'Error updating your location, please select your location manually';
  static String location_permission_error =
      'Please enable location permission to detect your location';

  // -- OTP Validation Screen
  static String otp_validation_screen_title = 'OTP Verification';
  static String otp_validation_enter_otp =
      'Please enter OTP sent on your email';
  static String otp_validation_entered_otp = 'Entered OTP:';
  static String otp_validation_invalid_otp_error =
      'Invalid OTP. Please enter a 6-digit OTP.';
  static String otp_validation_submit_button = 'Submit OTP';
  static String otp_validation_error_message =
      'Error occurred while verifying OTP, please try again.';

  // -- Register Screen
  static String register_screen_title = 'Join Satiety';
  static String register_email_exists_message =
      'Email already exists, please try again with different email';
  static String register_email_invalid = 'Please enter a valid email address';
  static String register_phone_number_invalid =
      'Phone number must be exactly 10 digits';
  static String register_email_empty = 'Please enter your email';
  static String register_enter_valid_email = 'Please enter a valid email';
  static String register_phone_number_empty = 'Please enter your phone number';
  static String register_phone_exists_message =
      'Phone number already exists, please try again with different email';

  // -- Login Screen
  static String login_user_not_found = 'User not found, please try again';
  static String login_invalid_credentials =
      'Invalid credentials, please try again';
  static String login_error =
      'Error occurred while logging in, please try again';

  // -- List View Scree
  static String list_view_screen_title = 'Food List';

  // -- Post Ad
  static String post_ad_user_address = 'Your approximate Address';
  static String post_ad_image_select = 'Please select an image';
  static String post_ad_enter_food_name = 'Please enter food name';

  // -- Supplier Location Map
  static String supplier_location_map_title = 'Select Location';
  static String supplier_location_map_search_hint = 'Search for a place...';
  static String supplier_location_map_select_place = 'Select this location';
  static String supplier_location_map_pick_up_location = 'Puck up location';

  // -- Food Details
  static String food_details_map_marker = 'Supplier Location';
  static String food_details_map_supplier_address =
      'Supplier approximate Address';
  static String food_details_request_failed =
      'Request failed, please try again';
  static String food_details_request_success = 'Food request sent successfully';
  static String food_details_request_button = 'Request Food';
  static String food_details_allergy_String =
      'View Food Allergen Information Here';
  static String food_details_self_request_failed =
      'You cannot request for food added by you';

  // -- My Listings
  static String my_listings_screen_title = 'My Listings';
  static String my_listings_screen_no_listings = 'No listings available';
  static String my_listings_error_accept_request =
      'Error accepting request, please try again';
  static String my_listings_error_decline_request = 'Error declining request';
  static String my_listings_error_cancel_request = 'Error cancelling request';
  static String my_listings_received_requests = 'Received Requests:';

  // -- My Requests
  static String my_requests_screen_title = 'My Requests';
  static String my_requests_screen_no_listings = 'No listings found';
  static String my_requests_no_requests_available = 'No requests available';
  static String my_requests_request_cancelled =
      'Request cancelled successfully';

  // -- User Profile
  static String user_profile_screen_title = 'My Profile';

  // -- Information Guide
  static String info_guide_Location_msg =
      'Shows Location distance from the supplier or consumer';
  static String info_guide_food_type_red = 'This food is Non-Vegetarian Food';
  static String info_guide_food_type_green = 'This food is Vegetarian Food';
  static String info_guide_food_type_orange =
      'This food is vegetarian and non-vegetarian both type of Food';
  static String info_guide_price_red = 'This listed food is Chargeable';
  static String info_guide_price_green = 'This listed food is Free of Cost';

  // -- Messages
  static String messages_screen_title = 'Messages';
}
