#!/usr/bin/env bash

set -u

# ---------------------------------------------------------------------------
# Cores
# ---------------------------------------------------------------------------
readonly AMARELO='\033[1;33m'
readonly VERMELHO='\033[1;31m'
readonly VERDE='\033[1;32m'
readonly AZUL='\033[1;34m'
readonly RESET='\033[0m'

readonly LARGURA=62

# ---------------------------------------------------------------------------
# Funcoes de exibicao
# ---------------------------------------------------------------------------
linha() {
    local cor="$1"
    printf '%b+' "$cor"
    printf '%*s' "$LARGURA" '' | tr ' ' '-'
    printf '+%b\n' "$RESET"
}

texto_centralizado() {
    local texto="$1"
    local cor="$2"
    local espaco=$(( LARGURA - ${#texto} ))
    local esq=$(( espaco / 2 ))
    local dir=$(( espaco - esq ))
    printf '%b|%*s%s%*s|%b\n' "$cor" "$esq" '' "$texto" "$dir" '' "$RESET"
}

caixa_titulo() {
    local texto="$1"
    local cor="$2"
    linha "$cor"
    texto_centralizado "$texto" "$cor"
    linha "$cor"
}

mensagem() {
    local texto="$1"
    local cor="$2"
    printf '%b%s%b\n' "$cor" "$texto" "$RESET"
}

# ---------------------------------------------------------------------------
# Inicio
# ---------------------------------------------------------------------------
caixa_titulo "SISTEMA DE TESTES AUTOMATIZADO" "$AMARELO"
echo

read -r -p "Caminho do projeto: " PROJECT_PATH
while [[ ! -d "$PROJECT_PATH" ]]; do
    read -r -p "Caminho invalido. Digite novamente: " PROJECT_PATH
done
PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"

while true; do
    read -r -p "Quantidade de testes: " TEST_COUNT
    if [[ "$TEST_COUNT" =~ ^[0-9]+$ ]] && (( TEST_COUNT > 0 )); then
        break
    fi
    mensagem "Quantidade invalida." "$VERMELHO"
done

mapfile -t SOURCE_FILES < <(find "$PROJECT_PATH" -type f -name '*.c' -not -path '*/build/*' -not -path '*/results/*' | sort)

if (( ${#SOURCE_FILES[@]} == 0 )); then
    mensagem "Nenhum arquivo .c encontrado." "$VERMELHO"
    exit 1
fi

mkdir -p "$PROJECT_PATH/build"
EXECUTABLE="$PROJECT_PATH/build/sussygado"

echo
mensagem "Compilando projeto..." "$AZUL"

if ! gcc -std=c99 -pedantic -Wall "${SOURCE_FILES[@]}" -o "$EXECUTABLE" -lm; then
    mensagem "Falha na compilacao." "$VERMELHO"
    exit 1
fi

mensagem "Compilacao concluida com sucesso." "$AZUL"
echo
caixa_titulo "EXECUTANDO TESTES" "$AMARELO"
echo

for ((i = 1; i <= TEST_COUNT; i++)); do
    IN_FILE="$PROJECT_PATH/t${i}.in"
    RES_FILE="$PROJECT_PATH/t${i}.res"
    OUT_FILE="$PROJECT_PATH/t${i}.out"

    if [[ ! -f "$IN_FILE" || ! -f "$RES_FILE" ]]; then
        mensagem "Teste ${i}: ignorado (falta .in ou .res)." "$VERMELHO"
        continue
    fi

    if "$EXECUTABLE" <"$IN_FILE" >"$OUT_FILE"; then
        if sdiff -s "$RES_FILE" "$OUT_FILE" >/dev/null; then
            mensagem "Teste ${i}: OK" "$VERDE"
        else
            mensagem "Teste ${i}: Fracasso. Diferenca encontrada:" "$VERMELHO"
            sdiff -s "$RES_FILE" "$OUT_FILE"
            echo
        fi
    else
        mensagem "Teste ${i}: falha na execucao do programa" "$VERMELHO"
    fi
done

echo
caixa_titulo "TESTES FINALIZADOS" "$AMARELO"