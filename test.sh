#!/bin/bash
# Создаю директории
for i in {1..5}; 
do
  mkdir -p "$i"
  check_success "Не удалось создать директорию $i"
done
echo "Созданы директории 1-5."


for i in {1..5}; do
  for j in {1..1000}; do
    filename="${i}KB_$(date +%Y-%m-%d_%H-%M-%S)_$j.dat"
    dd if=/dev/urandom of="$i/$filename" bs=$(( i * 1024 )) count=1
    check_success "Не удалось создать файл $i/$filename"
    files["$i,$j"]="$filename"
  done
done
echo "Созданы файлы в директориях 1-5."

mkdir -p "backup"
check_success "Не удалось создать директорию backup"
cp -r {1..5} backup/
check_success "Не удалось скопировать директории в backup"
echo "Директории 1-5 скопированы в backup."


mkdir -p "final_backup"
check_success "Не удалось создать директорию final_backup"
mv backup final_backup/
check_success "Не удалось переместить директорию backup в final_backup"
echo "Директория backup перемещена в final_backup."



for i in {1..5}; do
  for j in {1..1000}; do
    original_file="${i}/${files["$i,$j"]}"
    copied_file="final_backup/backup/$i/${files["$i,$j"]}"
    
    if [ ! -f "$copied_file" ]; then
      echo "Ошибка: Скопированный файл '$copied_file' не существует."
      exit 1
    fi
    
    if cmp -s "$original_file" "$copied_file"; then
      echo "Файл '$copied_file' идентичен оригинальному файлу."
    else
      echo "Файл '$copied_file' отличается от оригинального файла."
    fi
  done
done
echo "Сравнение файлов завершено."

rm -r {1..5}
check_success "Не удалось удалить директории 1-5"
echo "Начальные директории"

for i in {2..5..2}; do
  for j in {1..1000}; do
    if (( j % 2 != 0 )); then
      file="final_backup/backup/$i/${files["$i,$j"]}"
      rm -f "$file"
      echo "Удален файл '$file'."
    fi
  done
done
echo "Удаление нечетных файлов в четных директориях завершено."

echo "Скрипт завершен успешно"

