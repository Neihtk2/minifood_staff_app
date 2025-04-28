String removeDiacritics(String str) {
  const withDiacritics =
      'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ'
      'ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ';
  const withoutDiacritics =
      'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd'
      'AAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';

  for (int i = 0; i < withDiacritics.length; i++) {
    str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
  }
  return str;
}

bool isSimilar(String text, String query) {
  if (text.length < query.length) return false;

  int distance = levenshteinDistance(text, query);
  return distance <= 2; // cho phép sai tối đa 2 ký tự
}

int levenshteinDistance(String s, String t) {
  if (s == t) return 0;
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;

  List<List<int>> matrix = List.generate(
    s.length + 1,
    (_) => List<int>.filled(t.length + 1, 0),
  );

  for (int i = 0; i <= s.length; i++) matrix[i][0] = i;
  for (int j = 0; j <= t.length; j++) matrix[0][j] = j;

  for (int i = 1; i <= s.length; i++) {
    for (int j = 1; j <= t.length; j++) {
      int cost = s[i - 1] == t[j - 1] ? 0 : 1;
      matrix[i][j] = [
        matrix[i - 1][j] + 1, // xóa
        matrix[i][j - 1] + 1, // thêm
        matrix[i - 1][j - 1] + cost, // thay
      ].reduce((a, b) => a < b ? a : b);
    }
  }

  return matrix[s.length][t.length];
}
