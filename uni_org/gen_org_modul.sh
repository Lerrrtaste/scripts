#!/usr/bin/env bash

# MODUL="Visual Computing"
# SHORT="GDV"
# output_file="out/visual_computing.org"

MODUL="Entscheidungstheorie"
SHORT="ET"
output_file="out/entscheidungstheorie.org"

# MODUL="Datenbanken 2"
# SHORT="DB2"
# output_file="out/datenbanken2.org"
#
# MODUL="Theoretische Informatik"
# SHORT="TI"
# output_file="out/theoretische_informatik.org"

# MODUL="Verteilte Systeme"
# SHORT="VS"
# output_file="out/verteilte_systeme.org"

# MODUL="Informatik und Gesellschaft"
# SHORT="IG"
input_file="output.txt"
# output_file="out/informatik_gesellschaft.org"

# MODUL="IT-Controlling"
# SHORT="ITC"
# output_file="out/it_controlling.org"

# MODUL="Analysis"
# SHORT="ga"
# output_file="out/analysis.org"


# idxs
counter_v=1
counter_u=1
counter_p=1

# contents
vorlesungen=""
uebungen=""
praktika=""
pruefung=""


echo "#+title: ${MODUL}" > "${output_file}"
echo "#+CATEGORY: ${SHORT}" >> "${output_file}"
echo "" >> "${output_file}"
echo "" >> "${output_file}"
echo "* General" >> "${output_file}"
echo ":original_date_file:">> "${output_file}"
echo "$(cat $input_file)" >> "${output_file}"
echo ":end:" >> "${output_file}"
echo "" >> "${output_file}"
echo "" >> "${output_file}"

while IFS= read -r line; do
    date=$(echo "${line}" | awk '{print $2}' | awk -F. '{printf "%s-%02d-%02d", $3, $2, $1}')
    time=$(echo "${line}" | awk '{print $3}')
    location=$(echo "${line}" | awk '{print $4}')
    event_type=$(echo "${line}" | awk '{print $5}')
    # print debug to console
    echo "Event: ${event_type} at ${date}"

  if [[ "${event_type}" == "V:" ]]; then
    vorlesungen+="** ${MODUL} V-${counter_v}\n"
    vorlesungen+="   SCHEDULED: <${date} ${time}>\n"
    vorlesungen+="   :PROPERTIES:\n"
    vorlesungen+="   :ID: $(echo $SHORT | tr '[:upper:]' '[:lower:]')-v-${counter_v}\n"
    vorlesungen+="   :LOCATION: ${location}\n"
    vorlesungen+="   :END:\n\n"
    counter_v=$((counter_v + 1))

  elif [[ "${event_type}" == "Ü:" ]]; then
    uebungen+="** ${MODUL} Ü-${counter_u}\n"
    uebungen+="   SCHEDULED: <${date} ${time}>\n"
    uebungen+="   :PROPERTIES:\n"
    uebungen+="   :ID: $(echo $SHORT | tr '[:upper:]' '[:lower:]')-ü-${counter_u}\n"
    uebungen+="   :LOCATION: ${location}\n"
    uebungen+="   :END:\n\n"
    uebungen+="*** TODO Vorbereiten [[id:$(echo $SHORT | tr '[:upper:]' '[:lower:]')-ü-${counter_u}][${SHORT} Ü-${counter_u}]]\n"
    uebungen+="DEADLINE: <${date} -1d>\n\n"
    counter_u=$((counter_u + 1))

  elif [[ "${event_type}" == "P:" ]]; then
    praktika+="** ${MODUL} P-${counter_p}\n"
    praktika+="   SCHEDULED: <${date} ${time}>\n"
    praktika+="   :PROPERTIES:\n"
    praktika+="   :ID: $(echo $SHORT | tr '[:upper:]' '[:lower:]')-p-${counter_p}\n"
    praktika+="   :LOCATION: ${location}\n"
    praktika+="   :END:\n\n"
    praktika+="*** TODO Vorbereiten [[id:$(echo $SHORT | tr '[:upper:]' '[:lower:]')-p-${counter_p}][${SHORT} P-${counter_p}]]\n"
    praktika+="DEADLINE: <${date} -1d>\n\n"
    counter_p=$((counter_p + 1))

  elif [[ "${event_type}" == "S:" ]]; then
    praktika+="** ${MODUL} S-${counter_p}\n"
    praktika+="   SCHEDULED: <${date} ${time}>\n"
    praktika+="   :PROPERTIES:\n"
    praktika+="   :ID: $(echo $SHORT | tr '[:upper:]' '[:lower:]')-s-${counter_p}\n"
    praktika+="   :LOCATION: ${location}\n"
    praktika+="   :END:\n\n"
    praktika+="DEADLINE: <${date} -1d>\n\n"
    counter_p=$((counter_p + 1))

  else
    pruefung+="* ?? ${MODUL} - Prüfung :LN:\n"
    pruefung+="   SCHEDULED: <${date} ${time}>\n"
    pruefung+="   :PROPERTIES:\n"
    pruefung+="   :ID: $(echo $SHORT | tr '[:upper:]' '[:lower:]')-ln\n"
    pruefung+="   :LOCATION: ${location}\n"
    pruefung+="   :END:\n\n"
    pruefung+="full line (unknown event, probably prüfung):"
    pruefung+="${line}"

  fi


done < "${input_file}"

# write
echo "* Vorlesungen :V:" >> "${output_file}"
echo -e "${vorlesungen}" >> "${output_file}"
echo "" >> "${output_file}"
echo "* Übungen :Ü:" >> "${output_file}"
echo -e "${uebungen}" >> "${output_file}"
echo "" >> "${output_file}"
echo "* Praktika :P:" >> "${output_file}"
echo -e "${praktika}" >> "${output_file}"
echo "" >> "${output_file}"
echo -e "${pruefung}" >> "${output_file}"
echo "" >> "${output_file}"
