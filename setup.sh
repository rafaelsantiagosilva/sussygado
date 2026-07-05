#!/usr/bin/env bash

VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
RESET='\033[0m' 

if [ "$#" -ne 2 ]; then
    echo -e "${VERMELHO}Erro: Parâmetros ausentes.${NC}"
    echo "Uso: $0 <nome_do_programa> <numero_de_testes>"
    exit 1
fi

program_name=$1
tests=$2

if ! [[ "$tests" =~ ^[0-9]+$ ]]; then
    echo -e "${VERMELHO}Erro: O segundo parâmetro ('$tests') deve ser um número inteiro positivo.${RESET}"
    exit 1
fi

mkdir -p "$program_name"
touch "${program_name}/${program_name}.c"

for (( i=1; i<=tests; i++ ))
do
    touch "${program_name}/t${i}.in" "${program_name}/t${i}.res"
done

echo -e "${VERDE}Sucesso: Estrutura para '$program_name' criada com $tests testes.${RESET}"