import 'package:flutter/material.dart';

class AppColors {
  // NavBar
  static const Color backgroundNavBar = Color(0xFFdf9a04);
  static const Color activeNavBarButton = Color(0xFF031A6E);
  static const Color inativeNavBarButton = Color(0xFFFFFFFF);
  // Button
  static const Color onHoverButton = Color(0xFFf0c14b);
  static const Color backgroundButton = Color(0xFFdf9a04);
  // Others
  static const Color header = Color(0xFFdf9a04);
  static const Color background = Color(0xFFFFFFFF);
  // Text
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF093030);

  static const Color contentColorGreen = Color(0xFF28812E);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorOrange = Color(0xFFFF683B);

}

class Utils {
  /**
   *  Cria um AppBar com o título passado por parâmetro
   *
   *  @param title - Título do AppBar
   */
  static AppBar buildHeader(String title,) {
    return AppBar(
      backgroundColor: AppColors.header,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      centerTitle: true,
    );
  } // buildHeader

  /**
   *  Cria um rodapé com informações de direitos autorais
   *
   *  @returns - Widget do rodapé
   */
  static Widget buildFooter( )
  {
    return BottomAppBar(
      color: AppColors.backgroundNavBar,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "© 2025 - Todos os direitos reservados",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Show Coin",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  } // buildFooter

  /**
   *  Cria um botão com o texto e a função passados por parâmetro
   *
   *  @param text - Texto do botão
   *
   *  @param onPressed - Função a ser executada ao clicar no botão
   *
   *  @param color - Cor do botão
   *
   *  @param onhouver - Cor do botão ao passar o mouse por cima
   *
   *  @param width - Largura do botão
   *
   *  @param height - Altura do botão
   */
  static Widget buildButton({
    required String text,
    required VoidCallback onPressed,
    Color color = AppColors.backgroundButton,
    Color onhouver = AppColors.onHoverButton,
    double width = 200,
    double height = 50,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        onHover: (value) {
          if (value) {
            color = onhouver;
          } else {
            color = color;
          }
        },
      ),
    );
  } // buildButton

  static Widget buildText(
    String text, {
      Color color = AppColors.textPrimary,
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      TextOverflow overflow = TextOverflow.ellipsis,
      int maxLines = 1,
      double? padTop,
      double? padBottom,
      double? padLeft,
      double? padRight,
      double? marginTop,
      double? marginBottom,
      double? marginLeft,
      double? marginRight,
    }) {
    return Padding(
      padding: EdgeInsets.only(
        top: padTop ?? 0,
        bottom: padBottom ?? 0,
        left: padLeft ?? 0,
        right: padRight ?? 0,
      ),
      child: Container(
        margin: EdgeInsets.only(
          top: marginTop ?? 0,
          bottom: marginBottom ?? 0,
          left: marginLeft ?? 0,
          right: marginRight ?? 0,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            textAlign: textAlign,
            overflow: overflow,
            maxLines: maxLines,
          ),
        ),
      ),
    );
  } // buildText

  /**
   *  Cria um campo de texto com o label, o controller, o tipo e a visibilidade
   *  passados por parâmetro
   *
   *  @param label - O texto que aparecerá como rótulo no campo
   *
   *  @param controller - Gerencia o estado do texto digitado.
   *
   *  @param type - Define o tipo de teclado (ex: numérico, texto, email).
   *
   *  @param obscure - Indica se o texto será ocultado (exemplo: senha).
   */
  static Widget buildInputField(
    String label, {
    required TextEditingController controller,
    required TextInputType type,
    required bool obscure,
    double? width,
    double? height,
  }) {
    return _PasswordField(
      label: label,
      controller: controller,
      type: type,
      obscure: obscure,
      width: width,
      height: height,
    );
  } // buildInputField

  /**
   *  Exibe um diálogo de alerta com o título, o conteúdo e as funções de
   *  confirmação e cancelamento passados por parâmetro
   *
   *  @param context - Contexto da aplicação
   *
   *  @param title - Título do diálogo
   *
   *  @param content - Conteúdo/Descrição do diálogo
   *
   *  @param onConfirm - Função a ser executada ao confirmar
   *
   *  @param confirmText - Texto do botão de confirmação
   *
   *  @param cancelText - Texto do botão de cancelamento
   *
   *  @param confirmButtonColor - Cor do botão de confirmação
   *
   *  @param cancelButtonColor - Cor do botão de cancelamento
   */
  static void showAlertDialog(
    BuildContext context,
    String title,
    String content, {
    required VoidCallback onConfirm,
    String confirmText = "Confirmar",
    String cancelText = "Cancelar",
    Color confirmButtonColor = AppColors.backgroundButton,
    Color cancelButtonColor = Colors.grey,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title, textAlign: TextAlign.center,),
            content: Text(content, textAlign: TextAlign.center,),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Utils.buildButton(
                    text: cancelText,
                    onPressed: () => Navigator.pop(context),
                    color: cancelButtonColor,
                    width: double.infinity, // Ocupa toda a largura disponível
                  ),
                  const SizedBox(height: 10),
                  Utils.buildButton(
                    text: confirmText,
                    onPressed: onConfirm,
                    color: confirmButtonColor,
                    width: double.infinity,
                  ),
                ],
              ),
            ],
          ),
    );
  } // showAlertDialog
} // Utils

// ! Classe privada
// ! Lógica para criar um campo de senha com visibilidade
class _PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final bool obscure;
  final double? width;
  final double? height;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.type,
    required this.obscure,
    this.width,
    this.height,
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          widget.width ??
          double.infinity, // Se não for passado, usa largura total
      height: widget.height ?? 60, // Altura padrão de 60 se não especificado
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.type,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: widget.label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon:
                widget.obscure
                    ? IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: _toggleVisibility,
                    )
                    : null,
          ),
        ),
      ),
    );
  }
} // _PasswordField
