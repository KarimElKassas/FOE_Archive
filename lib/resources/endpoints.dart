class EndPoints{
  static const String baseUrl = 'http://172.16.1.75:9300/api';
  static const String authEnd = '$baseUrl/User';
  static const String letterEnd = '$baseUrl/Letter';
  static const String fileEnd = '$baseUrl/File';
  static const String receivedDepartmentsEnd = '$baseUrl/RecivedDepartment';
  static const String directionEnd = '$baseUrl/Direction';
  static const String tagEnd = '$baseUrl/Tag';
  static const String sectorEnd = '$baseUrl/Sector';
  static const String departmentEnd = '$baseUrl/Department';
  static const String login = '$authEnd/authenticate';
  static const String getUser = '$authEnd/getUser';
  static const String getLetters = '$letterEnd/GetAllLettersByDepartmentId';
  static const String getIncomingLetters = '$receivedDepartmentsEnd/GetAllIncomingLetters';
  static const String getOutgoingLetters = '$letterEnd/GetAllOutgoingLetters';
  static const String getArchivedLetters = '$letterEnd/GetAllArchiveLetters';
  static const String getForMeLetters = '$letterEnd/GetAllForMeLetters';
  static const String getLetterById = '$letterEnd/GetLetterById';
  static const String createLetter = '$letterEnd/CreateLetter';
  static const String createArchivedLetter = '$letterEnd/CreateArchiveLetter';
  static const String createForMeLetter = '$letterEnd/CreateForMeLetter';
  static const String uploadLetterFiles = '$fileEnd/CreateFile';
  static const String getDirections = '$directionEnd/GetAllDirections';
  static const String getTags = '$tagEnd/GetAllMyTags';
  static const String getAllSectors = '$sectorEnd/GetAllSectors';
  static const String getDepartmentsBySector = '$departmentEnd/GetAllDepartmentsBySectorId';
  static const String getAllDepartments = '$departmentEnd/GetAllDepartments';
}