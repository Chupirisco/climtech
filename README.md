# ClimTech ☁️

O **ClimTech** é um aplicativo de previsão do tempo desenvolvido em Flutter com foco em unir **meteorologia e design moderno** em uma experiência simples, leve e agradável de usar.

O projeto foi criado com a proposta de exibir informações climáticas de forma prática, utilizando a localização atual do dispositivo ou permitindo que o usuário pesquise cidades brasileiras manualmente. A ideia principal sempre foi transformar dados meteorológicos em algo visualmente bonito, intuitivo e fácil de entender.

## ✨ Principais funcionalidades

* Clima atual em tempo real
* Previsão do tempo para até 14 dias
* Probabilidade de chuva
* Geolocalização automática
* Busca manual de cidades do Brasil
* Sistema de favoritos
* Tema claro e escuro
* Interface moderna inspirada no estilo iOS
* Widgets com efeito visual semelhante a “liquid glass”

## 🎨 Design

Um dos principais focos do ClimTech é a interface.

O app utiliza um visual clean e moderno, trabalhando principalmente com tons brancos e pretos suavizados para criar uma aparência elegante e confortável visualmente. Os widgets possuem fundos translúcidos inspirados no conceito de *liquid glass*, trazendo uma identidade própria para o projeto.

A experiência foi pensada para ser simples, organizada e agradável tanto no tema claro quanto no escuro.

[Protótipo no Figma](https://www.figma.com/design/SQiS0hzKZ9o0EIiSOq01aF/app-clima?node-id=54-870&t=RzEw6KqIhyNOfgug-1)

[Apresentação do Projeto](https://www.figma.com/proto/SQiS0hzKZ9o0EIiSOq01aF/app-clima?page-id=0%3A1&node-id=6-86&p=f&viewport=1075%2C307%2C0.2&t=dqg5gtIGMf5T6sX7-1&scaling=min-zoom&content-scaling=fixed&starting-point-node-id=6%3A86)

## 🇧🇷 Foco no Brasil

O ClimTech foi desenvolvido com foco principal no Brasil.

A busca de cidades funciona utilizando dados do IBGE, permitindo encontrar municípios brasileiros de forma rápida e gratuita. Apesar disso, a geolocalização automática pode funcionar em outros países, já que os dados climáticos são obtidos através de APIs globais.

## 📡 APIs e tecnologias utilizadas

### Desenvolvimento

* Dart
* Flutter
* Arquitetura MVVM
* Provider

### APIs

* Open-Meteo → previsão do tempo
* Nominatim → geolocalização e busca de coordenadas
* IBGE → pesquisa de cidades brasileiras

### Bibliotecas

* Geolocator
* Iconify
* Outras bibliotecas da comunidade Flutter

### UI

* Fonte Poppins
* Temas personalizados
* Interface responsiva e minimalista

## 📌 Precisão dos dados

O aplicativo utiliza dados meteorológicos fornecidos pela Open-Meteo, que trabalha com estações meteorológicas internacionais. Mesmo não sendo uma solução profissional paga, os resultados costumam apresentar uma margem de diferença pequena, geralmente entre **0° e 2°** em comparação com a temperatura real.

A proposta do projeto é oferecer uma solução bonita, funcional e acessível utilizando apenas ferramentas gratuitas.

## 🚧 Futuras melhorias

Algumas funcionalidades planejadas para versões futuras incluem:

* Novos widgets climáticos
* Exibição de temperaturas máximas e mínimas
* Avisos e informações meteorológicas adicionais
* Melhorias visuais e de usabilidade

## 💡 Objetivo do projeto

Além de ser um aplicativo funcional, o ClimTech também foi desenvolvido como um projeto de portfólio e aprendizado, mostrando como é possível criar uma aplicação moderna de meteorologia utilizando Flutter, APIs gratuitas e um cuidado especial com design e experiência do usuário.
