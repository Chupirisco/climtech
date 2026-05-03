import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:climtech/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../view_models/select_location_viewmodel.dart';

class LocationSearchWidget extends StatefulWidget {
  const LocationSearchWidget({super.key});

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _EstadoCombobox(),
        const SizedBox(height: 12),
        _CidadeCombobox(),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ESTADO COMBOBOX
// ─────────────────────────────────────────────────────────────────────────────

class _EstadoCombobox extends StatefulWidget {
  @override
  State<_EstadoCombobox> createState() => _EstadoComboboxState();
}

class _EstadoComboboxState extends State<_EstadoCombobox> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _showOverlay = false;
  bool _suppressListener = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChanged);
  }

  SelectLocationViewmodel get _vm => context.read<SelectLocationViewmodel>();

  void _onFocusChange() {
    if (!_focusNode.hasFocus) _hideOverlay();
  }

  void _onTextChanged() {
    if (_suppressListener) return;
    final hasResults = _vm.onStateQueryChanged(_controller.text);
    if (_controller.text.isEmpty) _vm.clearState();
    hasResults ? _showOverlayIfNeeded() : _hideOverlay();
  }

  void _showOverlayIfNeeded() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _showOverlay = true);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_showOverlay) setState(() => _showOverlay = false);
  }

  void _onSelect(BrazilianState state) {
    _suppressListener = true;
    _controller.text = state.name;
    _suppressListener = false;
    _vm.selectState(state);
    _hideOverlay();
    _focusNode.unfocus();
  }

  OverlayEntry _buildOverlayEntry() {
    // 📐 LARGURA DO DROPDOWN — lemos a largura real do input via RenderBox
    // para que o painel de opções tenha exatamente o mesmo tamanho do campo.
    // Esse é o único lugar onde o tamanho do dropdown é definido.
    // Para uma largura fixa, substitua `inputWidth` por um valor fixo, ex: 300.0
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double inputWidth = renderBox.size.width; // 📐 LARGURA: altere aqui

    return OverlayEntry(
      builder: (_) => _DropdownOverlay<BrazilianState>(
        layerLink: _layerLink,
        // 📐 A largura calculada acima é repassada ao overlay
        width: inputWidth,
        suggestionsBuilder: () =>
            context.read<SelectLocationViewmodel>().stateSuggestions,
        itemBuilder: (s) => _StateTile(state: s, onTap: () => _onSelect(s)),
        onTapOutside: _hideOverlay,
      ),
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.select((SelectLocationViewmodel vm) => vm.selectedState);
    return CompositedTransformTarget(
      link: _layerLink,
      child: _SearchField(
        controller: _controller,
        focusNode: _focusNode,
        hint: 'Estado',
        active: _showOverlay,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CIDADE COMBOBOX
// ─────────────────────────────────────────────────────────────────────────────

class _CidadeCombobox extends StatefulWidget {
  @override
  State<_CidadeCombobox> createState() => _CidadeComboboxState();
}

class _CidadeComboboxState extends State<_CidadeCombobox> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _showOverlay = false;
  bool _suppressListener = false;
  BrazilianState? _lastState;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChanged);
  }

  SelectLocationViewmodel get _vm => context.read<SelectLocationViewmodel>();

  void _onFocusChange() {
    if (!_focusNode.hasFocus) _hideOverlay();
  }

  void _onTextChanged() {
    if (_suppressListener) return;
    if (!_vm.cityEnabled) return;
    if (_controller.text.isEmpty) {
      _vm.clearCity();
      _hideOverlay();
      return;
    }
    _vm.onCityQueryChanged(_controller.text);
    _showOverlayIfNeeded();
  }

  void _showOverlayIfNeeded() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _showOverlay = true);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_showOverlay) setState(() => _showOverlay = false);
  }

  void _onSelect(String city) {
    _suppressListener = true;
    _controller.text = city;
    _suppressListener = false;
    _vm.selectCity(city);
    _hideOverlay();
    _focusNode.unfocus();
  }

  OverlayEntry _buildOverlayEntry() {
    // 📐 LARGURA DO DROPDOWN — mesmo princípio do _EstadoCombobox acima
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final double inputWidth = renderBox.size.width; // 📐 LARGURA: altere aqui

    return OverlayEntry(
      builder: (_) {
        final vm = context.read<SelectLocationViewmodel>();
        return _DropdownOverlay<String>(
          layerLink: _layerLink,
          // 📐 A largura calculada acima é repassada ao overlay
          width: inputWidth,
          loading: vm.cityLoading,
          suggestionsBuilder: () => vm.citySuggestions,
          itemBuilder: (c) => _CityTile(city: c, onTap: () => _onSelect(c)),
          onTapOutside: _hideOverlay,
        );
      },
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SelectLocationViewmodel>();
    final enabled = vm.cityEnabled;

    if (_lastState != vm.selectedState) {
      _lastState = vm.selectedState;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _suppressListener = true;
        _controller.clear();
        _suppressListener = false;
        _hideOverlay();
      });
    }

    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: _SearchField(
        controller: _controller,
        focusNode: _focusNode,
        hint: enabled ? 'Cidade' : 'Selecione um estado primeiro',
        enabled: enabled,
        active: _showOverlay,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DROPDOWN OVERLAY
// ─────────────────────────────────────────────────────────────────────────────

class _DropdownOverlay<T> extends StatelessWidget {
  final LayerLink layerLink;
  final List<T> Function() suggestionsBuilder;
  final Widget Function(T) itemBuilder;
  final VoidCallback onTapOutside;
  final bool loading;

  // 📐 LARGURA: recebida de quem cria o overlay (RenderBox do input)
  // Para largura fixa, passe um valor constante, ex: width: 300
  final double width;

  const _DropdownOverlay({
    required this.layerLink,
    required this.suggestionsBuilder,
    required this.itemBuilder,
    required this.onTapOutside,
    required this.width, // 📐 LARGURA: parâmetro obrigatório
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = suggestionsBuilder();
    final tema = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTapOutside,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.transparent)),
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 56),
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                // 📐 LARGURA APLICADA: é aqui que o tamanho é de fato imposto
                // ao painel do dropdown. Altere `width` acima para mudar.
                width: width,
                child: Container(
                  decoration: BoxDecoration(
                    color: tema.onSecondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: loading
                      ? SizedBox(
                          height: 56,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: tema.primary,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < suggestions.length; i++) ...[
                              itemBuilder(suggestions[i]),
                              if (i < suggestions.length - 1)
                                Divider(height: 1, color: tema.primary),
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SEARCH FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool enabled;
  final bool active;

  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.enabled = true,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      decoration: BoxDecoration(
        color: enabled ? tema.onPrimary : tema.onSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Iconify(AppIcons.lupa, color: tema.primary, size: 20.sp),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              style: estiloTexto(15),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: estiloTexto(15, cor: tema.secondary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TILES
// ─────────────────────────────────────────────────────────────────────────────

class _StateTile extends StatelessWidget {
  final BrazilianState state;
  final VoidCallback onTap;

  const _StateTile({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(children: [Text(state.name, style: estiloTexto(15))]),
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  final String city;
  final VoidCallback onTap;

  const _CityTile({required this.city, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: tema.primary, size: 16),
            const SizedBox(width: 10),
            Expanded(child: Text(city, style: estiloTexto(15))),
          ],
        ),
      ),
    );
  }
}
