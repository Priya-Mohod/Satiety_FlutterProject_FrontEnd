class StringConstants {
  // -- General
  static String exception_error = 'Error connecting server, please try again';
  static String internet_error = 'Please check your internet connection!';
  static String server_error = 'Error connecting server, please try again';

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

  // -- List View Screen
  static String list_view_screen_title = 'Food List';

  // -- Post Ad
  static String post_ad_user_address = 'Your approximate Address';
  static String post_ad_image_select = 'Please select an image';
  static String post_ad_enter_food_name = 'Please enter food name';

  // -- Supplier Location Map
  static String supplier_location_map_title = 'Choose Pickup Location';
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
}
