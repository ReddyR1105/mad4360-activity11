import 'package:flutter/material.dart';
import '../validators.dart';
import '../widgets/local_tips.dart';
import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _birthDate;
  String? _selectedCreatureType;
  bool _obscurePassword = true;
  bool _submitting = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SuccessScreen(
          userName: _nameController.text.trim(),
          creatureType: _selectedCreatureType!,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2008),
      firstDate: DateTime(1920),
      lastDate: now,
    );
    if (!mounted || picked == null) return;
    setState(() {
      _birthDate = picked;
      _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Enchanted Signup Lab')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Choose your creature companion',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Demo signup only. No account is created or stored.',
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const Key('name'),
                    controller: _nameController,
                    validator: validateName,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('email'),
                    controller: _emailController,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('password'),
                    controller: _passwordController,
                    validator: validatePassword,
                    obscureText: _obscurePassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('birthday'),
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    validator: (_) =>
                        _birthDate == null ? 'Pick your birth date' : null,
                    decoration: const InputDecoration(
                      labelText: 'Birth Date',
                      prefixIcon: Icon(Icons.cake_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: const Key('creature'),
                    initialValue: _selectedCreatureType,
                    decoration: const InputDecoration(
                      labelText: 'Creature Type',
                      prefixIcon: Icon(Icons.pets_outlined),
                    ),
                    items:
                        const [
                              'Ghost',
                              'Bat',
                              'Black Cat',
                              'Pumpkin Spirit',
                              'Witch',
                            ]
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCreatureType = value),
                    validator: (value) =>
                        value == null ? 'Choose a creature type' : null,
                  ),
                  const SizedBox(height: 22),
                  FilledButton(
                    key: const Key('submit'),
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Register Creature'),
                  ),
                  const SizedBox(height: 24),
                  const LocalTips(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
