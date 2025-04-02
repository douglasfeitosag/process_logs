#!/bin/bash

while true; do
    echo "Iniciando execução do wrk..."
    wrk -t12 -c100 -d60 -s script.lua http://localhost:8080/
    echo "Execução concluída. Reiniciando..."
    sleep 120
done