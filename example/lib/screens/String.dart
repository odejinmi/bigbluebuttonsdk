// var baseurl = 'meetingapp.convergenceondemand.com/';
var apibaseurl = "https://govsupport.convergenceondemand.com/conferencing/api/";
var token = "";

String generateInitials(String fullName) {
  // Trim and check if the fullName is empty
  if (fullName.trim().isEmpty) {
    return ''; // Return an empty string if input is empty
  }

  // Split the name into parts
  List<String> nameParts = fullName.trim().split(' ');

  // If there's only one name part, return the first letter
  if (nameParts.length == 1) {
    return nameParts[0][0].toUpperCase();
  }

  // Otherwise, return the first letter of the first and last name
  String firstInitial = nameParts[0][0].toUpperCase();
  String lastInitial = nameParts[nameParts.length - 1][0].toUpperCase();

  return firstInitial + lastInitial;
}