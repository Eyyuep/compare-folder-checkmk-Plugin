#!/bin/bash

# Definiere Konstanten und Variablen
REMOTE_HOST="remotehost@192.168.41.131"
BACKUP_FOLDER="/home/remotehost/Backup-Ordner"
DOWNLOAD_FOLDER="/home/baran/Download-Ordner"

# Funktion für den SSH-Befehlsblock
check_missing_files() {
  ssh -n "$REMOTE_HOST" "cd \"$BACKUP_FOLDER\" && find . -type f" | while read file; do
    if [ ! -f "$DOWNLOAD_FOLDER/$file" ]; then
      echo "WARN: $file fehlt im Download-Ordner" >> backup_check_result.txt
    fi
  done
}

# Verbindet sich mit dem entfernten Server per SSH und zählt die Anzahl der Dateien im Backup-Ordner
backup_count=$(ssh -n "$REMOTE_HOST" "ls -1 \"$BACKUP_FOLDER\" | wc -l")

# Zählt die Anzahl der Dateien im Download-Ordner auf dem lokalen Client
download_count=$(ls -1 "$DOWNLOAD_FOLDER" | wc -l)

# Berechnet die prozentuale Übereinstimmung der Anzahl der Dateien im Backup-Ordner und im Download-Ordner
if [ "$backup_count" -ne 0 ]; then
    match_percent=$(echo "scale=2; ($download_count/$backup_count)*100" | bc)
else
    echo "echo \"<<<compare_files>>>\"" > backup_check_result.txt
    echo "1 - Der Backup-Ordner auf dem entfernten Server ist leer" >> backup_check_result.txt
    check_missing_files
    exit 1
fi

# Vergleicht die Anzahl der Dateien im Backup-Ordner mit der Anzahl der Dateien im Download-Ordner
if [ "$backup_count" -eq "$download_count" ]; then
    echo "echo \"<<<compare_files>>>\"" > backup_check_result.txt
    echo "2 - Anzahl der Dateien im Download-Ordner entspricht der Anzahl im Backup-Ordner ($backup_count von $backup_count)" >> backup_check_result.txt
    check_missing_files
    exit 2
elif (( $(echo "$match_percent >= 50 && $match_percent < 99" | bc -l) )); then
    echo "echo \"<<<compare_files>>>\"" > backup_check_result.txt
    echo "3 - Anzahl der Dateien im Download-Ordner entspricht nicht der Anzahl im Backup-Ordner ($download_count von $backup_count, $match_percent% Übereinstimmung)" >> backup_check_result.txt
    check_missing_files
    exit 3
else
    echo "echo \"<<<compare_files>>>\"" > backup_check_result.txt
    echo "4 - Es Befinden sich nur $download_count von $backup_count Datein im Downloadordner ($match_percent% Übereinstimmung)" >> backup_check_result.txt
    check_missing_files
    exit 4
fi
