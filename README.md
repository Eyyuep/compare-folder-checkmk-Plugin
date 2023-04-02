# compare-folder-checkmk-Plugin
Das Repository enthält zwei Skripte: Ein Python-Skript vergleicht Inhalte von Verzeichnissen. Ein Bash-Skript vergleicht Anzahl von Dateien auf einem Server mit lokalem Verzeichnis und schreibt Ergebnisse in eine Datei. Python-Skript liest Datei und generiert Warnungen.
# Checkmk Plugin: compare_files

Das Checkmk Plugin `compare_files` überwacht die Inhalte von zwei Ordnern, indem es die Anzahl und die Namen der Dateien in den Ordnern vergleicht. 

## Installation

1. Kopieren Sie das Plugin-Script `compare_files.py` in das Verzeichnis `/usr/lib/check_mk_agent/plugins/` auf dem Zielhost.
2. Stellen Sie sicher, dass das Script ausführbar ist (`chmod +x compare_files.py`).
3. Starten Sie den Checkmk-Agenten auf dem Zielhost neu.

## Verwendung

Das Plugin erkennt automatisch den zu überwachenden Ordner und liefert einen Service mit dem Namen "Ordner_Monitoring". Der Service wird in der Regel von einem Host mit einem bestimmten Namen erwartet, damit Checkmk ihn automatisch erkennt.

Das Plugin überprüft die beiden Ordner, indem es die Ergebnisse aus der Datei `/usr/lib/check_mk_agent/plugins/backup_check_result.txt` ausliest. Diese Datei wird vom Bashskript `Backup_comparison.sh` generiert, das separat installiert werden muss.

## Ergebnisse

Das Plugin liefert folgende Ergebnisse:

- `OK`: Beide Ordner haben den selben Inhalt.
- `WARN`: Die Anzahl der Dateien in den Ordnern weicht um 50-99% voneinander ab.
- `CRIT`: Die Anzahl der Dateien in den Ordnern weicht um 0-49% voneinander ab.
- `UNKNOWN`: Das Plugin konnte die Datei `backup_check_result.txt` nicht finden oder es ist ein unbekannter Fehler aufgetreten.

## Beispiel

Ein Beispiel-Output des Plugins könnte folgendermaßen aussehen:

## console
```OK - Beide Ordner haben den selben Inhalt```

## Autor
Dieses Plugin wurde von [name] entwickelt.

## Bashskript
Das Bashskript `Backup_comparison.sh` ist ein zusätzliches Skript, das separat installiert werden muss, um die Datei `/usr/lib/check_mk_agent/plugins/backup_check_result.txt` zu generieren, die vom Plugin `compare_files` ausgelesen wird. Hier ist der Inhalt der Datei: `<edit file>`https://github.com/Eyyuep/compare-folder-checkmk-Plugin/blob/main/Backup_comparison.sh`</edit file>`.

