import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:satietyfrontend/pages/Models/register_user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../Constants/StringConstants.dart';
import '../Constants/URLConstants.dart';
import '../Services/UserStorageService.dart';
import '../Views/SnackbarHelper.dart';

class Service {
  String url = URLConstants.url;

  Future<http.Response> convertStreamedResponse(
      StreamedResponse streamedResponse) async {
    final bytes = await streamedResponse.stream.toBytes();
    final response = http.Response.bytes(bytes, streamedResponse.statusCode,
        headers: streamedResponse.headers);
    return response;
  }

  // -- Login User
  Future<Response?> loginUser(String email, String password) async {
    try {
      final requestBody = {
        "username": email,
        "password": password,
      };
      String? customURL = await UserStorageService.getCustomURL();
      if (customURL != null) {
        url = customURL;
      }
      final response = await http.post(
        Uri.parse('$url/authenticateUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      print(response);
      return response;
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
    }

    return null;
  }

  // -- On click of Get OTP button, send mobile number to server
  Future<Response?> getOTPForMobileNumber(String mobileNumber) async {
    String? customURL = await UserStorageService.getCustomURL();
    if (customURL != null) {
      url = customURL;
    }
    var request =
        http.MultipartRequest('GET', Uri.parse('$url/sendOtpOnMobile'));
    // User Firstname -
    request.fields['mobile'] = mobileNumber;

    print(request);
    var response = await makeServerRequest(request);

    // Handle the response
    if (response != null && response.statusCode == 200) {
      // File upload successful
      print('OTP sent successfully');
      return convertStreamedResponseToResponse(response);
      // send response back to caller function
    } else if (response != null) {
      // File upload failed
      print('Error in OTP generation ${response.statusCode}');
      return null;
    }
    return null;
  }

  // -- on click of get email OTP, send email otp
  Future<Response?> getOTPForEmail(String email) async {
    String? customURL = await UserStorageService.getCustomURL();
    if (customURL != null) {
      url = customURL;
    }
    var request =
        http.MultipartRequest('GET', Uri.parse('$url/sendOtpOnEmail'));
    // User Firstname -
    request.fields['email'] = email;

    print(request);
    var response = await makeServerRequest(request);

    // Handle the response
    if (response != null && response.statusCode == 200) {
      // File upload successful
      print('OTP sent successfully');
      return convertStreamedResponseToResponse(response);
      // send response back to caller function
    } else if (response != null) {
      // File upload failed
      print('Error in OTP generation ${response.statusCode}');
      return null;
    }
    return null;
  }

  Future<bool> verifyOTPForMobileNumber(String mobileNumber, String OTP) async {
    String? customURL = await UserStorageService.getCustomURL();
    if (customURL != null) {
      url = customURL;
    }
    var request = http.MultipartRequest('GET', Uri.parse('$url/getOTP'));

    // User Firstname -
    request.fields['mobileNumber'] = mobileNumber;
    request.fields['OTP'] = OTP;

    print(request);
    var response = await makeServerRequest(request);

    // Handle the response
    if (response != null && response.statusCode == 200) {
      // File upload successful
      print('OTP verified successfully');
      return true;
      // send response back to caller function
    } else if (response != null) {
      // File upload failed
      print('Error in OTP verification ${response.statusCode}');
      return false;
    }
    return false;
  }

  Future<Response?> registerUser(
      File? userImage,
      String firstName,
      String lastName,
      String password,
      String mobile,
      String email,
      String pincode,
      String address,
      double latitude,
      double longitude,
      bool isRegister) async {
    String? customURL = await UserStorageService.getCustomURL();
    if (customURL != null) {
      url = customURL;
    }
    var request = http.MultipartRequest('POST',
        Uri.parse(isRegister ? '$url/registerUser' : '$url/updateUser'));
    var multipartFile;
    // User Image - sent using multipart request
    if (userImage != null) {
      File file = userImage;
      var fileStream = http.ByteStream(file.openRead());
      var length = await file.length();
      multipartFile = http.MultipartFile('file', fileStream, length,
          filename: path.basename(file.path));
    }
    // User Firstname -
    request.fields['firstName'] = firstName;
    // User Lastname -
    request.fields['lastName'] = "";
    // User Password -
    request.fields['password'] = password;
    // User Mobile -
    request.fields['mobile'] = mobile;
    // User Email -
    request.fields['email'] = email;
    // User Pincode -
    request.fields['pincode'] = pincode;
    // User Address -
    request.fields['address'] = address;
    // latitude -
    request.fields['latitude'] = '$latitude';
    // longitude -
    request.fields['longitude'] = '$longitude';

    // Add the MultipartFile to the request
    if (multipartFile != null) {
      request.files.add(multipartFile);
    }

    // Send the form data request
    print(request);
    var response = await makeServerRequest(request);

    // Handle the response
    if (response != null) {
      // File upload successful
      print('User data uploaded successfully');
      return convertStreamedResponseToResponse(response);
      // send response back to caller function
    } else {
      return null;
    }
  }

  Future<Response?> fetchFoodData(Map<String, String> filterDict) async {
    try {
      var storedLocation =
          await UserStorageService.retrieveLocationFromPreferences();
      var request = http.MultipartRequest('GET', Uri.parse('$url/getAllFood'));
      // -- get values from filterDict --
      // get values from filter dict
      String distanceFilter = "";
      if (filterDict.containsKey('distanceFilter')) {
        distanceFilter = filterDict['distanceFilter']!;
      }
      request.fields['distanceFilter'] = distanceFilter;
      request.fields['latitude'] = storedLocation!.latitude.toString();
      request.fields['longitude'] = storedLocation.longitude.toString();
      // -- check Food Type
      String foodType = "";
      if (filterDict.containsKey('foodTypeFilter')) {
        foodType = filterDict['foodTypeFilter']!;
      }
      request.fields['foodTypeFilter'] = foodType;

      // -- check Food Amount
      String foodAmount = "";
      if (filterDict.containsKey('foodAmountFilter')) {
        foodAmount = filterDict['foodAmountFilter']!;
      }
      request.fields['foodAmountFilter'] = foodAmount;

      // -- check Food Availability
      String foodAvailability = "";
      if (filterDict.containsKey('availabilityFilter')) {
        foodAvailability = filterDict['availabilityFilter']!;
      }
      request.fields['availabilityFilter'] = foodAvailability;

      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return convertStreamedResponseToResponse(response);
      } else {
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
    }

    return null;
  }

  Future<bool> sendFoodDetailsWithFile(
    String foodName,
    String foodDescription,
    int foodQuantity,
    String foodAddress, // Not Provided in code Yet
    String foodImageUri, // Not Provided in code Yet
    String foodType,
    File? image,
    double latitude,
    double longitude,
    String allergyString,
    String foodAmount,
    String foodAvailableFromDateTime,
    String foodAvailableToDateTime,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse('$url/addfood'));

    // Create a MultipartFile from the file you want to upload
    // Food Image - sent using multipart request
    File file = image!;
    var fileStream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', fileStream, length,
        filename: path.basename(file.path));
    // Food Name -
    request.fields['foodName'] = foodName;
    // Food Description -
    request.fields['foodDescription'] = foodDescription;
    // Food Quantity -
    request.fields['foodQuantity'] = '$foodQuantity';
    // Food Address -
    request.fields['foodAddress'] = foodAddress;
    // Food Food Type - // Veggies - Veg / Non-Veg / Vegan /
    request.fields['foodType'] = foodType;
    // Food Amount - Free / Chargeable
    // TODO : Move this parsing into ViewModel
    double amount = 0.0;
    if (foodAmount.isNotEmpty) {
      double doubleValue = double.parse(foodAmount);
      double roundedValue = double.parse(doubleValue.toStringAsFixed(1));
      amount = roundedValue;
    }
    request.fields['foodAmount'] = '$amount';
    // latitude -
    request.fields['latitude'] = '$latitude';
    // longitude -
    request.fields['longitude'] = '$longitude';
    // Allergy -
    request.fields['allergies'] = allergyString;
    // Food Available From Date Time -
    request.fields['availableFrom'] = foodAvailableFromDateTime;
    // Food Available To Date Time -
    request.fields['availableTo'] = foodAvailableToDateTime;

    // Add the MultipartFile to the request
    request.files.add(multipartFile);

    var response = await makeServerRequest(request);

    // Handle the response
    if (response != null && response.statusCode == 200) {
      // File upload successful
      print('Food data uploaded successfully');
      return true;
      // send response back to caller function
    } else if (response != null) {
      // File upload failed
      print('Food data failed with status code ${response.statusCode}');
      return false;
    }

    return false;
  }

  // TODO - Check Email Exists, returns complete user data
  Future<http.StreamedResponse?> fetchUserDataUsingEmail(String email) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$url/getUserByEmail'));
      request.fields['email'] = email;
      var response = await makeServerRequest(request);
      return response;
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
      return null;
    }
  }

  Future<http.StreamedResponse?> fetchedUserDataById(int userId) async {
    try {
      var request = http.MultipartRequest('GET', Uri.parse('$url/getUserById'));
      request.fields['id'] = '$userId';
      var response = await makeServerRequest(request);
      return response;
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
      return null;
    }
  }

  Future<bool> checkUserPhoneNumber(String phone) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$url/getUserByMobile'));
      request.fields['mobile'] = phone;
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
      return false;
    }
  }

  // Verify User OTP using Email
  Future<bool> verifyUserOTP(String email, int otp) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$url/verifyUserEmail'));
      request.fields['email'] = email;
      request.fields['emailOtp'] = otp.toString();
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');

      return false;
    }
  }

  // Request Food
  Future<bool> requestFood(int foodId) async {
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$url/requestForFood'));
      request.fields['foodId'] = '$foodId';
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');

      return false;
    }
  }

  // Get MyListings
  Future<Response?> getMyListings() async {
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$url/getMyListings'));
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return convertStreamedResponseToResponse(response);
      } else {
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');

      return null;
    }
  }

  // Get Requests
  Future<Response?> getMyRequests() async {
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$url/getMyRequests'));
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return convertStreamedResponseToResponse(response);
      } else {
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');

      return null;
    }
  }

  // Accept Request
  Future<bool> acceptRequest(int requestId) async {
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$url/acceptFoodRequest'));
      request.fields['foodRequestId'] = '$requestId';
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');

      return false;
    }
  }

  // Decline Request
  Future<bool> declineRequest(int requestId) async {
    try {
      var request =
          http.MultipartRequest('GET', Uri.parse('$url/deleteFoodRequest'));
      request.fields['foodRequestId'] = '$requestId';
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');

      return false;
    }
  }

  // Chat Request
  Future<Response?> fetchChatData(int foodRequestId) async {
    try {
      var request = http.MultipartRequest(
          'GET', Uri.parse('$url/getConversationsForFoodRequest'));
      request.fields['foodRequestId'] = '$foodRequestId';
      var response = await makeServerRequest(request);
      if (response != null && response.statusCode == 200) {
        final streamedResponse = await http.Response.fromStream(response);
        return streamedResponse;
      } else {
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      print('Exception: $e');
    }

    return null;
  }

  // Server call
  Future<http.StreamedResponse?> makeServerRequest(
      MultipartRequest request) async {
    bool isConnected = await checkInternetConnectivity();
    if (isConnected) {
      Map<String, String> headers = await getRequestHeader();
      request.headers.addAll(headers);
      var response = await request.send();
      return response;
    } else {
      // Show snack bar with no internet connection
      SnackbarHelper(StringConstants.internet_error);
      return null;
    }
  }

  // Check internet connectivity
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      return false;
    } else {
      // Internet connection is available
      return true;
    }
  }

  // Request header for all requests
  Future<Map<String, String>> getRequestHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String authToken =
        prefs.getString('authToken') ?? ''; // Default to empty string
    Map<String, String> headers = {
      'Authorization': authToken,
    };
    return headers;
  }

  Future<Response?> convertStreamedResponseToResponse(
      http.StreamedResponse httpResponse) async {
    final response = await http.Response.fromStream(httpResponse);
    return response;
  }
}
