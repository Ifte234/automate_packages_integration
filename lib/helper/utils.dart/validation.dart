class Validation {
 
  String? validateMapApiKey(String apiKey) {
    if (apiKey.isEmpty) {
      return 'API Key cannot be empty.';
    }
    if (!apiKey.startsWith('AIza')) {
      return 'API Key must start with "AIza".';
    }
    if (apiKey.length < 20) {
      return 'API Key is too short.';
    }
    return null;
  }
}
