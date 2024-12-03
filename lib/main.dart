import 'package:flutter/material.dart'; // Biblioteca principal para construir a interface do usuário no Flutter
import 'package:shared_preferences/shared_preferences.dart'; // Biblioteca para armazenamento local de dados (persistência de chave-valor)
import 'dart:math'; // Biblioteca para operações matemáticas, como cálculos com números aleatórios ou trigonometria
import 'dart:async'; // Biblioteca para manipulação de operações assíncronas e temporizadores (Timer, Future, etc.)

// Função principal que inicia o aplicativo Flutter
void main() {
  runApp(const WaterfyApp());
}

// Classe raiz do aplicativo que configura o MaterialApp
class WaterfyApp extends StatelessWidget {
  const WaterfyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WaterfyScreen(),
    );
  }
}

// Widget principal que representa a tela do aplicativo
class WaterfyScreen extends StatefulWidget {
  const WaterfyScreen({super.key});

  @override
  _WaterfyScreenState createState() => _WaterfyScreenState();
}

// Classe que gerencia o estado da tela principal
class _WaterfyScreenState extends State<WaterfyScreen>
    with SingleTickerProviderStateMixin {
  int dailyGoal = 0;
  int consumed = 0;

  late AnimationController _waveController;
  late Timer _midnightTimer;

  final Color primaryColor = const Color(0xFF443690);
  final Color secondaryColor = const Color(0xFF29205E);
  final Color containerColor = const Color(0xFF171332);
  final Color textColor = const Color(0xFFDADADA);

  // Método chamado ao inicializar o estado do widget
  @override
  void initState() {
    super.initState();

    _loadUserData();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _setupMidnightReset();
  }

// Método chamado ao destruir o widget
  @override
  void dispose() {
    _waveController.dispose();
    if (_midnightTimer.isActive) {
      _midnightTimer.cancel();
    }
    super.dispose();
  }

// Método para carregar os dados armazenados do usuário
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyGoal = prefs.getInt('dailyGoal') ?? 0;
      consumed = prefs.getInt('consumed') ?? 0;
    });
  }

// Método para salvar a meta diária no armazenamento local
  Future<void> _saveDailyGoal(int goal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyGoal', goal);
  }

// Método para salvar a quantidade de água consumida no armazenamento local
  Future<void> _saveConsumed(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('consumed', value);
  }

  // Configura um reset automático dos dados consumidos à meia-noite
  void _setupMidnightReset() {
    DateTime now = DateTime.now();
    DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeUntilMidnight = nextMidnight.difference(now);

    _midnightTimer = Timer(timeUntilMidnight, () {
      setState(() {
        consumed = 0;
        _saveConsumed(consumed);
      });

      _setupMidnightReset();
    });
  }

  // Método que constrói a interface principal do aplicativo
  @override
  Widget build(BuildContext context) {
    double progress = consumed / dailyGoal;
    int remaining = max(0, dailyGoal - consumed);

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          // Logo, Título e Botão de Reset
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/waterfy-logo.png'),
                        width: 26,
                        height: 26,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Waterfy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'PaytoneOne',
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _resetData,
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Seção que exibe a Meta Diária
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Meta Diária",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'PaytoneOne',
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _updateGoal,
                            child: Icon(Icons.edit, color: textColor, size: 28),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: _calculateRecommendation,
                            child: Icon(Icons.calculate,
                                color: textColor, size: 28),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$dailyGoal mL",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PaytoneOne',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Seção que exibe a Água Consumida
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Água Consumida",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'PaytoneOne',
                            ),
                          ),
                          GestureDetector(
                            onTap: _addConsumption,
                            child: Icon(Icons.edit, color: textColor, size: 28),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  top: 90,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: MediaQuery.of(context).size.height *
                                        0.55,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 20,
                                  child: Container(
                                    width: 150,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: containerColor,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Ainda falta",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'PaytoneOne',
                                          ),
                                        ),
                                        Text(
                                          "${remaining.clamp(0, dailyGoal)} mL",
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'PaytoneOne',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 90,
                                  child: AnimatedBuilder(
                                    animation: _waveController,
                                    builder: (context, child) {
                                      return CustomPaint(
                                        size: Size(
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                          MediaQuery.of(context).size.height *
                                              0.55,
                                        ),
                                        painter: WaterWavePainter(
                                          progress: progress,
                                          animationValue: _waveController.value,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para criar um widget reutilizável com título, valor e ícones de ação
  Widget _buildSection({
    required String title,
    required String value,
    required IconData editIcon,
    IconData? calculateIcon,
    required VoidCallback onEditTap,
    VoidCallback? onCalculateTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PaytoneOne',
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEditTap,
                    child: Icon(
                      editIcon,
                      color: textColor,
                    ),
                  ),
                  if (calculateIcon != null && onCalculateTap != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: GestureDetector(
                        onTap: onCalculateTap,
                        child: Icon(
                          calculateIcon,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'PaytoneOne',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função para exibir um modal de confirmação para limpar os dados do aplicativo
  void _resetData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFF443690),
          title: const Text(
            "Resetar Dados",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'PaytoneOne',
            ),
          ),
          content: const Text(
            "Você realmente deseja resetar todos os dados do aplicativo?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'PaytoneOne',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PaytoneOne',
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                setState(() {
                  dailyGoal = 0;
                  consumed = 0;
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Sim",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'PaytoneOne',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Função para atualizar a meta diária do usuário manualmente
  void _updateGoal() {
    int tempDailyGoal = dailyGoal;
    bool isValid = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFF443690),
              title: const Text(
                "Inserir Meta Manualmente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'PaytoneOne',
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Meta (mL)",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    tempDailyGoal = int.tryParse(value) ?? 0;
                    setModalState(() {
                      isValid = tempDailyGoal > 0 && tempDailyGoal <= 20000;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PaytoneOne',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isValid
                      ? () {
                          setState(() {
                            dailyGoal = tempDailyGoal;
                            _saveDailyGoal(dailyGoal);
                          });
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      color: isValid ? Colors.white : Colors.grey,
                      fontFamily: 'PaytoneOne',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Função para calcular a meta recomendada com base no peso e na altura do usuário
  void _calculateRecommendation() {
    double weight = 0;
    double height = 0;
    int recommendedGoal = 0;
    bool isWeightValid = true;
    bool isHeightValid = true;
    bool canSave = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFF443690),
              title: const Text(
                "Calcular Recomendação",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'PaytoneOne',
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Peso (kg)",
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        weight = double.tryParse(value) ?? 0;
                        setModalState(() {
                          isWeightValid = weight > 0 && weight <= 300;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Altura (cm)",
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        height = double.tryParse(value) ?? 0;
                        setModalState(() {
                          isHeightValid = height > 0 && height <= 230;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isWeightValid && isHeightValid
                          ? () {
                              setModalState(() {
                                recommendedGoal = (weight * 35).toInt();
                                canSave = true;
                              });
                            }
                          : null,
                      child: const Text("Calcular"),
                    ),
                    if (recommendedGoal > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "$recommendedGoal mL",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PaytoneOne',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PaytoneOne',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: canSave
                      ? () {
                          setState(() {
                            dailyGoal = recommendedGoal;
                            _saveDailyGoal(dailyGoal);
                          });
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      color: canSave ? Colors.white : Colors.grey,
                      fontFamily: 'PaytoneOne',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Função para atualizar o consumo de água
  void _addConsumption() {
    int tempConsumed = 0;
    bool isValid = true;
    bool canRemove = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFF443690),
              title: const Text(
                "Atualizar Consumo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'PaytoneOne',
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Quantidade em mL",
                    hintStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onChanged: (value) {
                    tempConsumed = int.tryParse(value) ?? 0;
                    setModalState(() {
                      isValid = tempConsumed > 0 &&
                          tempConsumed <= (dailyGoal - consumed);
                      canRemove = tempConsumed <= consumed;
                    });
                  },
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PaytoneOne',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: isValid && canRemove
                          ? () {
                              setState(() {
                                consumed -= tempConsumed;
                                _saveConsumed(consumed);
                              });
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text(
                        "Remover",
                        style: TextStyle(
                          color: (isValid && canRemove)
                              ? Colors.white
                              : Colors.grey,
                          fontFamily: 'PaytoneOne',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: isValid
                          ? () {
                              setState(() {
                                consumed += tempConsumed;
                                _saveConsumed(consumed);
                              });
                              Navigator.pop(context);
                            }
                          : null,
                      child: Text(
                        "Adicionar",
                        style: TextStyle(
                          color: isValid ? Colors.white : Colors.grey,
                          fontFamily: 'PaytoneOne',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Classe responsável por desenhar a animação de ondas de água dentro da garrafa
class WaterWavePainter extends CustomPainter {
  final double progress;
  final double animationValue;

  WaterWavePainter({required this.progress, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) {
      return;
    }

    final paint = Paint()..color = Colors.blue.withOpacity(0.8);

    final path1 = Path();
    final path2 = Path();

    final waveHeight1 = 5.0;
    final waveHeight2 = 7.5;
    final waveLength = size.width / 2;

    final double topOffset = 20.0;

    double yOffset = size.height * progress;
    if (progress == 0.0) {
      yOffset += topOffset;
    }

    final roundedRect = RRect.fromRectAndCorners(
      Rect.fromLTRB(0, yOffset, size.width, size.height),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    canvas.clipRRect(roundedRect);

    path1.moveTo(0, yOffset);
    for (double x = 0; x <= size.width; x++) {
      path1.lineTo(
        x,
        yOffset +
            waveHeight1 *
                sin((x / waveLength) * 2 * pi + animationValue * 2 * pi),
      );
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    // Segunda onda
    path2.moveTo(0, yOffset + 2);
    for (double x = 0; x <= size.width; x++) {
      path2.lineTo(
        x,
        yOffset +
            2 +
            waveHeight2 *
                sin((x / waveLength) * 2 * pi +
                    animationValue * 2 * pi +
                    pi / 2),
      );
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(
      path2,
      Paint()..color = Colors.blue.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

