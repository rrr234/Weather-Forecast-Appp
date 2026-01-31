import 'dart:math';

class PasswordResult {
  final String password;
  final String strength; // Weak, Medium, Strong

  PasswordResult({required this.password, required this.strength});
}

class PasswordApi {
  final Random _rand = Random.secure();

  PasswordResult generate({
    int length = 12,
    bool letters = true,
    bool numbers = true,
    bool symbols = false,
  }) {
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    const syms = '!@#\u0024%^&*()_+-=[]{};:,.<>?';

    final buffer = StringBuffer();
    final charPool = StringBuffer();

    if (letters) charPool.writeAll([lower, upper], '');
    if (numbers) charPool.write(nums);
    if (symbols) charPool.write(syms);

    final pool = charPool.toString();
    if (pool.isEmpty) {
      return PasswordResult(password: '', strength: 'No options selected');
    }

    for (var i = 0; i < length; i++) {
      buffer.write(pool[_rand.nextInt(pool.length)]);
    }

    final pwd = buffer.toString();
    final strength = _estimateStrength(pwd);
    return PasswordResult(password: pwd, strength: strength);
  }

  String _estimateStrength(String pwd) {
    var score = 0;
    if (pwd.length >= 8) score += 1;
    if (pwd.length >= 12) score += 1;
    if (RegExp(r'[A-Z]').hasMatch(pwd) && RegExp(r'[a-z]').hasMatch(pwd)) score += 1;
    if (RegExp(r'[0-9]').hasMatch(pwd)) score += 1;
    if (RegExp(r'[!@#\u0024%\^&\*(),._+\-=[\]{};:<>?]').hasMatch(pwd)) score += 1;

    if (score <= 2) return 'Weak';
    if (score == 3) return 'Medium';
    return 'Strong';
  }
}
