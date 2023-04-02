from typing import List
from .agent_based_api.v1 import *

# Entdeckt den Dienst für die Überwachung der Ordner
def discover_compare_files(section):
    yield Service()

# Funktioniert und muss angepasst werden
def check_compare_files(section):
    try:
        with open('/usr/lib/check_mk_agent/plugins/backup_check_result.txt') as f:
            lines = f.readlines()
            status_line = lines[1].strip()
            path_line = lines[1].strip()

            for line in lines[1:]:
                # FALL 1 Ordner wurde nicht gefunden
                if line.startswith("1"):
                    yield Result(state=State.WARN, summary=f"{status_line} - Nur der erste Ordner enthält Dateien")
                    return
                # FALL 2 Beide Ordner haben den selben Inhalt
                elif line.startswith("2"):
                    yield Result(state=State.OK, summary=f"{status_line} - Beide Ordner haben den selben Inhalt")
                    return
                # FALL 3 Anzahl der Dateien weichen voneinander ab (50-99 % Übereinstimmung)
                elif line.startswith("3"):
                    yield Result(state=State.WARN, summary=f"{status_line} - Die Anzahl der Dateien weicht voneinander ab (50-99 % Übereinstimmung)")
                    return
                # FALL 4 Anzahl der Dateien weichen voneinander (ab 0-49 % Übereinstimmung)
                elif line.startswith("4"):
                    yield Result(state=State.CRIT, summary=f"{status_line} - Die Anzahl der Dateien weicht voneinander ab (0-49 % Übereinstimmung)")
                    break
            else:
                # Kein Fehler aufgetreten, beide Ordner gefunden und Ergebnisse verglichen // state=state.OK überschreibt ständig meine anderen werte.
                yield Result(state=State.OK, summary=f"{status_line} - Ergebnisse wurden erfolgreich verglichen")

    except FileNotFoundError:
        # backup_check_result.txt wurde nicht gefunden
        yield Result(state=State.UNKNOWN, summary="backup_check_result.txt wurde nicht gefunden")

    except:
        # Andere Fehler aufgetreten
        yield Result(state=State.UNKNOWN, summary="Ein unbekannter Fehler ist aufgetreten")

register.check_plugin(
    name="compare_files",
    service_name="Ordner_Monitoring",
    discovery_function=discover_compare_files,
    check_function=check_compare_files,
)
