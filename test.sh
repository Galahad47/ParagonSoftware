#!/bin/bash
# Создаю директории
for i in {1..5}; 
do
  mkdir -p "$i"
  echo "Создана директория $i"
done
# в каждой ддиректории по 1000 файлов создаю
for i in {1..5}; 
do
  for j in {1..1000}; 
  do
    dd if=/dev/urandom of="$i/file$j" bs=1 count=1
    echo "Создан файл $i/file$j"
  done
done
# задаю размер для каждого файла (в КБ)
for i in {1..5}; # читаю каждую директорию
do
  for j in {1..1000}; # каждый файл
  do
    ((size = i + 1)) # размер в зависимости от названия(а почему нет?)
    dd if=/dev/urandom of="$i/file$j" bs=$size count=1
    echo "Файл $i/file$j имеет размер $size КБ"
  done
done


for i in {1..5}; 
do
  for j in {1..1000}; 
  do
    file_name="$i/file$j" # в каждой директории смотрю каждый файл
    file_size=$(stat -c %s "$file_name") 
    file_name="${file_name}.${file_size}KB-${date +%Y-%m-%d-%H:%M}"
    mv "$file_name" "$file_name.bak" # тут добавляю размер и дату
    echo "Файл переименован в $file_name.bak"
  done
done

mkdir backup
for i in {1..5}; 
do
  cp -r "$i" backup/
  echo "Директория $i скопирована в backup/"
done

mkdir final #тут можно и не пояснять )
mv backup final/
echo "Директория backup перемещена в диркекторию final/"

for i in {1..5}; 
do
  rmdir "$i"
  echo "Директория $i удалена"
done

#тут сложнее чуток, потому что нужно было сравнивать содержимое файлов от 1 - 5 директории
for i in {1..5}; 
do
  for j in {1..1000}; 
  do
    file1="$i/file$j.bak"
    file2="$final/backup/$i/file$j.bak"
    if cmp -s "$file1" "$file2"; 
    then
      echo "Файлы совпадают: $file1 и $file2"
    else
      echo "Файлы различаются: $file1 и $file2"
    fi
  done
done

# тут смухлевал чуток и в доки залез ибо забыл элементарщину) 
for i in {2..4}; 
do
  for j in {1..1000}; 
  do
    file_name="$i/file$j.bak"
    if [ $j % 2 != 0 ]; 
    then
      rm "$file_name"
      echo "Файл $file_name удален"
    fi
  done
done

echo "Скрипт завершен успешно"

