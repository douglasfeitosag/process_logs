#!/bin/bash

while true; do
    echo "Iniciando execução do wrk..."
    wrk -t"$THREADS" -c"$CONNECTIONS" -d"$DURATION" -s script.lua "$URL"
    echo "Execução concluída. Reiniciando..."
done