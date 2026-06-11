Map<String, String> authorizedHeader(String token) {
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}

Map<String, String> formHeader() {
  return {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };
}

