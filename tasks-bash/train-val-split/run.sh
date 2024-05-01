#!/usr/bin/bash

function file_path_valdation() {
    if [ -f "$1" ]; then
        if [ "${1##*.}" != "csv" ]; then
            echo "wrong file extension"
            exit
        fi
    else
        echo ""$1" file does not exists or it is not file"
        exit
    fi
}

function create_or_clear_file() {
    if [ -e "$1" ]; then
        : > "$1"
    else
        touch "$1"
    fi
}

function split_files () {
    total_lines=$(wc -l < "$1")
    train_file_lines=$((total_lines * "$2"/100))

    head -n "$train_file_lines" "$1" > "$3"
    tail -n +$((train_file_lines + 1)) "$1" > "$4"
}


for arg in "$@"; do
  case $arg in
    --input=*) input_path="${arg#*=}";;
    --train_ratio=*) train_ratio="${arg#*=}";;
    --train_file=*) train_file="${arg#*=}";;
    --val_file=*) val_file="${arg#*=}";;
    --shuffle) shuffle=true;;
    *) echo "Unknown argument: $arg";;
  esac
done


file_path_valdation "$input_path"
create_or_clear_file "$train_file"
create_or_clear_file "$val_file"


if [ "$shuffle" == true ]; then
    shuf "$input_path" > tmp.csv
    split_files tmp.csv "$train_ratio" "$train_file" "$val_file"
    rm tmp.csv
else
    split_files "$input_path" "$train_ratio" "$train_file" "$val_file"
fi