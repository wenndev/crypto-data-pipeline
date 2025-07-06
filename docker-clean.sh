#!/bin/bash

echo "Parando e removendo todos os containers..."
containers=$(docker ps -aq)
if [ -n "$containers" ]; then
  docker rm -f $containers
else
  echo "Nenhum container para remover."
fi

echo "Removendo todas as imagens..."
images=$(docker images -q)
if [ -n "$images" ]; then
  docker rmi -f $images
else
  echo "Nenhuma imagem para remover."
fi

echo "Removendo todos os volumes..."
volumes=$(docker volume ls -q)
if [ -n "$volumes" ]; then
  docker volume rm $volumes
else
  echo "Nenhum volume para remover."
fi

echo "Removendo todas as networks (exceto bridge, host e none)..."
networks=$(docker network ls --format '{{.ID}} {{.Name}}' | grep -vE ' bridge$| host$| none$' | awk '{print $1}')
if [ -n "$networks" ]; then
  docker network rm $networks
else
  echo "Nenhuma network para remover."
fi

echo "Limpeza completa!"


