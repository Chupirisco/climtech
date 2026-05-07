class BrazilianState {
  final String name;
  final String code;
  const BrazilianState({required this.name, required this.code});

  // ─── Estados brasileiros ───────────────────────────────────────────────────
  static const List<BrazilianState> allStates = [
    BrazilianState(name: 'Acre', code: 'AC'),
    BrazilianState(name: 'Alagoas', code: 'AL'),
    BrazilianState(name: 'Amapá', code: 'AP'),
    BrazilianState(name: 'Amazonas', code: 'AM'),
    BrazilianState(name: 'Bahia', code: 'BA'),
    BrazilianState(name: 'Ceará', code: 'CE'),
    BrazilianState(name: 'Distrito Federal', code: 'DF'),
    BrazilianState(name: 'Espírito Santo', code: 'ES'),
    BrazilianState(name: 'Goiás', code: 'GO'),
    BrazilianState(name: 'Maranhão', code: 'MA'),
    BrazilianState(name: 'Mato Grosso', code: 'MT'),
    BrazilianState(name: 'Mato Grosso do Sul', code: 'MS'),
    BrazilianState(name: 'Minas Gerais', code: 'MG'),
    BrazilianState(name: 'Pará', code: 'PA'),
    BrazilianState(name: 'Paraíba', code: 'PB'),
    BrazilianState(name: 'Paraná', code: 'PR'),
    BrazilianState(name: 'Pernambuco', code: 'PE'),
    BrazilianState(name: 'Piauí', code: 'PI'),
    BrazilianState(name: 'Rio de Janeiro', code: 'RJ'),
    BrazilianState(name: 'Rio Grande do Norte', code: 'RN'),
    BrazilianState(name: 'Rio Grande do Sul', code: 'RS'),
    BrazilianState(name: 'Rondônia', code: 'RO'),
    BrazilianState(name: 'Roraima', code: 'RR'),
    BrazilianState(name: 'Santa Catarina', code: 'SC'),
    BrazilianState(name: 'São Paulo', code: 'SP'),
    BrazilianState(name: 'Sergipe', code: 'SE'),
    BrazilianState(name: 'Tocantins', code: 'TO'),
  ];
}
