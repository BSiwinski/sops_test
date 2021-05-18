#!/bin/bash

ENC_REGEX='*.enc'
DEC_REGEX='*.yml'

decrypt(){
  files=($(find . -name $ENC_REGEX))
  for i in "${files[@]}"
  do
	  echo $i ${i%.*}
    echo decrypting $i...
    sops --input-type yaml --output-type yaml -d $i > ${i%.*}
  done
}

encrypt(){
  export EDITOR='vim -s commands.txt'
  files=($(find . -name $ENC_REGEX))
  for i in "${files[@]}"
  do
    echo encrypting $i...
    sed -i "s=:.-1read.*=:.-1read ${i%.*}=" commands.txt
    sops --input-type yaml --output-type yaml $i
  done
}

show_help(){
  echo "Usage:"
  echo "decrypt                - decrypt all files matching regex $ENC_REGEX" 
  echo "encrypt                - encrypt files"
}

case "$1" in
  decrypt)
    decrypt
    exit 0
  ;;
  encrypt)
    encrypt
    exit 0
  ;;
  *)
    show_help
  exit 1
esac
