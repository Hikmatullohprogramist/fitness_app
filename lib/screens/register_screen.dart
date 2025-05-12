import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../services/auth_service.dart';
import '../models/auth_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _personalInfoKey = GlobalKey<FormState>();
  final _educationInfoKey = GlobalKey<FormState>();
  final _accountInfoKey = GlobalKey<FormState>();

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _universityController = TextEditingController();
  final _majorController = TextEditingController();
  final _courseController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _addressController = TextEditingController();

  // Form state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  String? _selectedGender;
  DateTime? _selectedDate;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Page control
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<String> _genders = ['Erkak', 'Ayol'];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedHeight = 165;
  int _selectedWeight = 65;
  int _selectedAge = 20;

  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.1, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _universityController.dispose();
    _majorController.dispose();
    _courseController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galereyadan tanlash'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _profileImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _validatePersonalInfo() {
    return _personalInfoKey.currentState?.validate() ?? false;
  }

  bool _validateEducationInfo() {
    return _educationInfoKey.currentState?.validate() ?? false;
  }

  bool _validateAccountInfo() {
    return _accountInfoKey.currentState?.validate() ?? false;
  }

  void _nextPage() {
    bool canContinue = false;
    switch (_currentPage) {
      case 0:
        canContinue = _validatePersonalInfo();
        break;
      case 1:
        canContinue = _validateEducationInfo();
        break;
    }

    if (canContinue) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage--;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authModel = AuthModel(
          email: _emailController.text,
          password: _passwordController.text,
          name: '${_firstNameController.text} ${_lastNameController.text}',
        );

        final response = await _authService.register(authModel);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Iltimos, shartlar va qoidalarga roziligingizni bildiring'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(prefixIcon,
                  color: Theme.of(context).colorScheme.primary),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
              image: _profileImage != null
                  ? DecorationImage(
                      image: FileImage(_profileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _profileImage == null
                ? Icon(
                    Icons.person_add,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _genderButton('Erkak', Icons.male, _selectedGender == 'Erkak'),
        const SizedBox(width: 24),
        _genderButton('Ayol', Icons.female, _selectedGender == 'Ayol'),
      ],
    );
  }

  Widget _genderButton(String gender, IconData icon, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          color:
              selected ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                size: 28),
            const SizedBox(width: 10),
            Text(
              gender,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgePicker() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text('Yoshingiz nechida ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        Text('$_selectedAge',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: Theme.of(context).colorScheme.primary,
          ),
          child: Slider(
            min: 10,
            max: 80,
            value: _selectedAge.toDouble(),
            onChanged: (val) {
              setState(() {
                _selectedAge = val.round();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeightPicker() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text('Bo\'yingiz necha santimetr ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        Text('cm', style: TextStyle(color: Colors.grey.shade500)),
        const SizedBox(height: 8),
        Text('$_selectedHeight',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: Theme.of(context).colorScheme.primary,
          ),
          child: Slider(
            min: 140,
            max: 210,
            value: _selectedHeight.toDouble(),
            onChanged: (val) {
              setState(() {
                _selectedHeight = val.round();
                _heightController.text = _selectedHeight.toString();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeightPicker() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text('Og\'irligingiz necha kilogram ?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 16),
        Text('kg', style: TextStyle(color: Colors.grey.shade500)),
        const SizedBox(height: 8),
        Text('$_selectedWeight',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            activeTrackColor: Theme.of(context).colorScheme.primary,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: Theme.of(context).colorScheme.primary,
          ),
          child: Slider(
            min: 30,
            max: 180,
            value: _selectedWeight.toDouble(),
            onChanged: (val) {
              setState(() {
                _selectedWeight = val.round();
                _weightController.text = _selectedWeight.toString();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNamePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 48),
          const Text('Keling tanishamiz!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 24),
          _buildInputField(
            controller: _firstNameController,
            label: 'Ism',
            hint: 'Ismingizni kiriting',
            prefixIcon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ism kiriting';
              }
              return null;
            },
          ),
          _buildInputField(
            controller: _lastNameController,
            label: 'Familiya',
            hint: 'Familiyangizni kiriting',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Familiya kiriting';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            _buildGenderSelector(),
            const SizedBox(height: 32),
            _buildAgePicker(),
            const SizedBox(height: 32),
            _buildHeightPicker(),
            const SizedBox(height: 32),
            _buildWeightPicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationInfoPage() {
    return Form(
      key: _educationInfoKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qayerda o\'qiysiz  ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _universityController,
              label: 'OTM nomi',
              hint: 'Universiteti nomini kiriting',
              prefixIcon: Icons.school,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'OTM nomini kiriting';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _majorController,
              label: 'Yo\'nalishi',
              hint: 'Mutaxassisligingizni kiriting',
              prefixIcon: Icons.book,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Yo\'nalishni kiriting';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _courseController,
              label: 'Kursi',
              hint: 'Nechinchi kurs',
              prefixIcon: Icons.class_,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kursni kiriting';
                }
                int? course = int.tryParse(value);
                if (course == null || course < 1 || course > 6) {
                  return 'Kurs 1-6 oralig\'ida bo\'lishi kerak';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoPage() {
    return Form(
      key: _accountInfoKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Akkaunt ma\'lumotlaringizni kiriting',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _emailController,
              label: 'Email',
              hint: 'example@mail.com',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email kiriting';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Yaroqli email kiriting';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _phoneController,
              label: 'Telefon raqami',
              hint: '+998XXXXXXXXX',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Telefon raqamini kiriting';
                }
                if (value.length < 9) {
                  return 'Yaroqli telefon raqami kiriting';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _passwordController,
              label: 'Parol',
              hint: 'Kamida 6 ta belgi',
              prefixIcon: Icons.lock,
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Parol kiriting';
                }
                if (value.length < 6) {
                  return 'Parol kamida 6 ta belgidan iborat bo\'lishi kerak';
                }
                return null;
              },
            ),
            _buildInputField(
              controller: _confirmPasswordController,
              label: 'Parolni tasdiqlang',
              hint: 'Parolni takrorlang',
              prefixIcon: Icons.lock,
              obscureText: !_isConfirmPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Parolni tasdiqlang';
                }
                if (value != _passwordController.text) {
                  return 'Parollar mos kelmadi';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CheckboxListTile(
                value: _acceptTerms,
                onChanged: (bool? value) {
                  setState(() {
                    _acceptTerms = value ?? false;
                  });
                },
                title: const Text(
                  'Men shartlar va qoidalarga roziman',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton.icon(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Orqaga'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            )
          else
            const SizedBox.shrink(),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _currentPage == 3 ? _register : _nextPage,
                icon: Icon(
                  _currentPage == 3 ? Icons.check : Icons.arrow_forward,
                  color: Colors.white,
                ),
                label:
                    Text(_currentPage == 3 ? 'Ro\'yxatdan o\'tish' : 'Keyingi'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.surface,
            ],
            stops: const [0.0, 0.3, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentPage == 0
                              ? 'Ism va familiya'
                              : _currentPage == 1
                                  ? 'Shaxsiy maʼlumotlar'
                                  : _currentPage == 2
                                      ? 'Taʼlim maʼlumotlari'
                                      : 'Akkaunt maʼlumotlari',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    if (_currentPage < 3)
                      TextButton.icon(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            _currentPage++;
                          });
                        },
                        label: const Text('O\'tkazish ->'),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              _buildPageIndicator(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _buildNamePage(),
                              _buildPersonalInfoPage(),
                              _buildEducationInfoPage(),
                              _buildAccountInfoPage(),
                            ],
                          ),
                        ),
                        _buildNavigationButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
