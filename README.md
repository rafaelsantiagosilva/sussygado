<div align="center"><h1>🧑‍💻 Sussygado 🧪</h1></div>

O projeto `Sussygado` consiste em um sistema que automatiza a execução de testes em um programa feito em `Linguagem C`. O objetivo dele é agilizar a vida de desenvolvedores que necessitam realizar testes de entrada e saída padrão com frequência, como os que competem em plataformas como [Beecrowd](https://judge.beecrowd.com/en/login), [Neps Academy](https://neps.academy/br), [OBI](https://olimpiada.ic.unicamp.br/) e [CodeForces](https://codeforces.com/).

## 🛠️ Tecnologias Utilizadas

![Shell Script](https://img.shields.io/badge/Shell_Script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)![Claude](https://img.shields.io/badge/Claude-D97757?style=for-the-badge&logo=claude&logoColor=white)![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)

## 👥 Participantes

- **Bruno Ferreira de Oliveira:** 257198
- **Henriquy Dias Terto Alves:** 312894
- **João Pedro Carvalho Rodrigues:** 312363
- **Rafael Santiago da Silva:** 313105

## 📋 Pré-requisitos

Antes de executar o projeto, garanta que seu sistema (Linux, macOS ou WSL no Windows) possui as seguintes ferramentas instaladas:

- **Bash** (versão 4 ou superior)
- **GCC** (compilador de `C`)
- **diffutils** (fornece o comando `sdiff`, usado para comparar as saídas dos testes)
- **Git** (para clonar o repositório)

Na maioria das distribuições Linux baseadas em Debian/Ubuntu, é possível instalar tudo com:

```bash
sudo apt update && sudo apt install build-essential diffutils git
```

## ⚙️ Como executar?

1. **Faça o download do projeto** ou clone o repositório:

```bash
git clone https://github.com/rafaelsantiagosilva/sussygado.git
```

2. Execute o `script de setup` com os seguintes parâmetros:

```bash
./setup.sh <nome_do_programa> <quantidade_de_testes>
```

Isso irá criar a pasta contendo o código fonte de seu programa - `<nome_do_programa>.c` - e a quantidade de arquivos de teste:
    - `t{n}.in:` representa o enésimo arquivo de entrada de teste
    - `t{n}.res`: representa o enésimo arquivo de resposta de teste

3. Codifique seu projeto em `Linguagem C` no arquivo de código fonte `.c` criado dentro da pasta. Preencha também cada arquivo `t{n}.in` com uma entrada de teste e o respectivo `t{n}.res` com a saída esperada para aquela entrada.

4. Rode o seguinte comando:

```bash
./main.sh
```

Isso irá gerar uma série de perguntas no terminal que devem ser respondidas da seguinte forma:

- **`Caminho do projeto:`** informe o caminho (absoluto ou relativo) da pasta gerada pelo `setup.sh`, ou seja, a pasta que contém o arquivo `.c` e os arquivos `t{n}.in`/`t{n}.res`. Caso o caminho informado não seja válido, o programa pedirá que você digite novamente.
- **`Quantidade de testes:`** informe quantos testes (`t1`, `t2`, `t3`...) o programa deve executar. O valor precisa ser um número inteiro positivo; caso contrário, será solicitado novamente.

A partir daí, o `Sussygado` assume o resto do trabalho automaticamente:

1. Procura todos os arquivos `.c` dentro da pasta informada (ignorando as subpastas `build/` e `results/`).
2. Compila o projeto com `gcc -std=c99 -pedantic -Wall -lm`, gerando o executável em `<caminho_do_projeto>/build/sussygado`.
3. Caso a compilação falhe, o processo é interrompido e o erro é exibido em vermelho.
4. Com a compilação concluída com sucesso, o programa passa a executar cada teste de `1` até a quantidade informada:
    - Se faltar o `.in` ou o `.res` de um teste, ele é **ignorado**.
    - O executável é rodado com o conteúdo do `t{n}.in` como entrada padrão, e a saída é salva em `t{n}.out`.
    - A saída gerada (`t{n}.out`) é comparada com a esperada (`t{n}.res`) usando `sdiff`.
    - Se as saídas forem idênticas, o teste é marcado como **OK**; caso contrário, as diferenças encontradas são exibidas logo abaixo do resultado do teste.

### 🎨 Legenda de cores

| Cor        | Significado                                                                        |
| ---------- | ---------------------------------------------------------------------------------- |
| 🟡 Amarelo  | Títulos e cabeçalhos do sistema                                                    |
| 🔵 Azul     | Mensagens referentes à compilação do projeto                                       |
| 🟢 Verde    | Teste executado com sucesso (saída idêntica à esperada)                            |
| 🔴 Vermelho | Erros de compilação, testes ignorados, falhas de execução ou testes com diferenças |

### 🖥️ Exemplo de execução

```text
+--------------------------------------------------------------+
|                SISTEMA DE TESTES AUTOMATIZADO                |
+--------------------------------------------------------------+

Caminho do projeto: ./meus_testes/soma
Quantidade de testes: 3

Compilando projeto...
Compilacao concluida com sucesso.

+--------------------------------------------------------------+
|                      EXECUTANDO TESTES                        |
+--------------------------------------------------------------+

Teste 1: OK
Teste 2: Fracasso. Diferenca encontrada:
< 15
---
> 16
Teste 3: ignorado (falta .in ou .res).

+--------------------------------------------------------------+
|                      TESTES FINALIZADOS                       |
+--------------------------------------------------------------+
```

> No terminal, os textos acima aparecem coloridos conforme a legenda apresentada anteriormente.

## 📁 Estrutura de arquivos esperada

Após rodar o `setup.sh` e codificar seu programa, a pasta do projeto deve se parecer com o exemplo abaixo (considerando 3 testes):

```text
meu_programa/
├── meu_programa.c
├── t1.in
├── t1.res
├── t2.in
├── t2.res
├── t3.in
├── t3.res
└── build/              # criada automaticamente pelo main.sh
    └── sussygado        # executável gerado pela compilação
```

Após a execução dos testes, arquivos `t{n}.out` também serão criados na pasta do projeto, contendo a saída real gerada pelo seu programa para cada teste.

## 💡 Observações

- Arquivos `.c` dentro das pastas `build/` e `results/` não são considerados na compilação.
- Se nenhum arquivo `.c` for encontrado na pasta informada, o programa é encerrado com uma mensagem de erro.
- O nome do executável gerado é sempre `sussygado`, independentemente do nome do programa informado no `setup.sh`.

<div align="center"><small>Feito com 💚</small></div>