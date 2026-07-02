#!/usr/bin/env bash

set -u

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
	printf 'Quantidade invalida.\n'
done

mapfile -t SOURCE_FILES < <(find "$PROJECT_PATH" -type f -name '*.c' -not -path '*/build/*' -not -path '*/results/*' | sort)

if (( ${#SOURCE_FILES[@]} == 0 )); then
	printf 'Nenhum arquivo .c encontrado.\n'
	exit 1
fi

mkdir -p "$PROJECT_PATH/build"
EXECUTABLE="$PROJECT_PATH/build/sussygado"

if ! gcc -std=c99 -pedantic -Wall "${SOURCE_FILES[@]}" -o "$EXECUTABLE" -lm; then
	printf 'Falha na compilacao.\n'
	exit 1
fi

for ((i = 1; i <= TEST_COUNT; i++)); do
	IN_FILE="$PROJECT_PATH/test_${i}.in"
	RES_FILE="$PROJECT_PATH/test_${i}.res"
	OUT_FILE="$PROJECT_PATH/test_${i}.out"

	if [[ ! -f "$IN_FILE" || ! -f "$RES_FILE" ]]; then
		printf 'Teste %d ignorado: falta .in ou .res.\n' "$i"
		continue
	fi

	if "$EXECUTABLE" <"$IN_FILE" >"$OUT_FILE"; then
		if sdiff -s "$RES_FILE" "$OUT_FILE" >/dev/null; then
			printf 'Teste %d: OK\n' "$i"
		else
			printf 'Teste %d: diferenca encontrada entre .res e .out\n' "$i"
			sdiff -s "$RES_FILE" "$OUT_FILE"
		fi
	else
		printf 'Teste %d: falha na execucao do programa\n' "$i"
	fi
done