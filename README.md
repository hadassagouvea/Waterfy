# Waterfy

## Flutter
Flutter é um framework de código aberto criado pelo Google, lançado oficialmente em dezembro de 2018. Ele permite o desenvolvimento de aplicativos nativos com uma única base de código para Android, iOS, web e desktop. A linguagem usada é o Dart, também criada pelo Google, que facilita o gerenciamento de estados, animações e interações. Flutter é amplamente utilizado para criar interfaces modernas e responsivas, graças à sua abordagem baseada em widgets. Um dos grandes diferenciais é sua renderização nativa direta, que oferece alta performance e personalização.

## Descrição do Projeto

![image](https://github.com/user-attachments/assets/b4345a0c-0518-4edf-adf0-5632cdc66ecf)

O **Waterfy** é um aplicativo intuitivo que ajuda o usuário a monitorar o consumo diário de água. Ele é especialmente útil para pessoas que desejam adotar hábitos saudáveis relacionados à hidratação. 

O aplicativo permite ao usuário:
- Definir uma meta diária de consumo de água em mililitros (mL).
- Registrar, manualmente, a quantidade de água consumida ao longo do dia.
- Visualizar, de forma gráfica e animada, o progresso no consumo, com uma garrafa preenchendo com água conforme o objetivo é alcançado.

Além disso, o **Waterfy** oferece funcionalidades como:
- Reset diário automático à meia-noite.
- Cálculo de meta recomendada baseado no peso e altura do usuário.
- Animações personalizadas das ondas da água dentro da garrafa, que representam dinamicamente o nível de consumo.

## Tecnologias
### Tecnologias Usadas
- **Flutter**: Framework principal utilizado para criar a interface e lógica do aplicativo.
- **Dart**: Linguagem de programação responsável por unir a lógica com a interface.
- **Shared Preferences**: Biblioteca para persistência de dados local, garantindo que informações como a meta diária e o consumo registrado estejam disponíveis mesmo após o fechamento do app.
- **CustomPainter**: Classe usada para criar gráficos e animações personalizadas no canvas do Flutter.
- **Biblioteca Math**: Usada para cálculos trigonométricos na criação do movimento das ondas.

### Persistência de Dados
Os dados do aplicativo, como o consumo diário e a meta, são armazenados localmente usando a biblioteca **Shared Preferences**. A abordagem de persistência é baseada em chave-valor, permitindo que informações sejam recuperadas rapidamente e mantidas mesmo quando o app é reiniciado.

### Animação das Ondas
A animação das ondas foi criada com a classe `CustomPainter`, que permite desenhar formas e gráficos no canvas. O movimento fluido foi obtido por cálculos matemáticos com funções trigonométricas (`sin`) para gerar o formato das ondas e sincronizá-las. As ondas desaparecem quando o progresso do consumo atinge 100%, criando uma interação visual agradável.

## Código
### Estrutura do Código
O código do **Waterfy** foi organizado para ser claro e modular. Aqui está uma visão geral:

#### Tela Inicial
A tela inicial foi construída com os seguintes componentes:
- **Cabeçalho**: Implementado com `Row`, contém o logo, nome do app e um botão para resetar os dados.
- **Seção de Meta Diária**: Mostra o valor da meta diária definida pelo usuário e botões para editar ou calcular a meta.
- **Seção de Água Consumida**: Exibe o progresso de consumo na garrafa animada. Inclui o valor restante para atingir a meta.

#### Persistência de Dados
A funcionalidade de salvar e carregar dados foi implementada usando `Shared Preferences`. Isso permite ao usuário:
- Salvar a meta diária ao definir ou calcular um valor.
- Registrar o consumo diário de água.
- Resetar automaticamente os dados consumidos à meia-noite.

#### Animação da Garrafa
A garrafa foi criada com widgets `CustomPaint` e `Stack` para posicionar as ondas dentro do corpo da garrafa. As ondas se ajustam dinamicamente ao progresso, começando com a garrafa "cheia" e desaparecendo completamente quando o consumo é 100%.

### Resumo de Como a Tela Foi Feita
- **Cabeçalho**: Criado com um `Row` centralizado, incluindo o logo e o botão de reset como ícone.
- **Seção de Meta Diária**: Usa `Container` estilizado para exibir a meta. Botões de edição e cálculo foram implementados com `GestureDetector`.
- **Seção de Água Consumida**: Inclui animações com ondas em movimento representando o progresso. Foi usado `AnimatedBuilder` para sincronizar as ondas com o estado atual do consumo.
- **Funções de Controle**: Métodos como `_resetData`, `_addConsumption` e `_calculateRecommendation` gerenciam a lógica por trás das interações do usuário.

## Conclusão
O **Waterfy** é um projeto que demonstra como o Flutter pode ser utilizado para criar aplicativos modernos, eficientes e com um alto nível de interatividade. A integração de animações dinâmicas com persistência local de dados oferece uma experiência rica e prática ao usuário. Este projeto também serve como um excelente exemplo de como unir lógica de negócios com uma interface visual atraente, evidenciando as possibilidades oferecidas por Flutter.
