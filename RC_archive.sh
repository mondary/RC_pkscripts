#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Archive
# @raycast.keyword archive
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName archive.sh

# Documentation:
# @raycast.description Create monthly archive on desktop
# @raycast.author Cmondary
# @raycast.authorURL https://github.com/mondary

# Définit le chemin du bureau
desktop_path="${HOME}/Desktop"

# Définit le chemin de l'archive (dossier "DesktopArchive" sur le bureau)
archive_path="${desktop_path}/DesktopArchive"

# Crée le dossier d'archive s'il n'existe pas
mkdir -p "${archive_path}"

# Obtient la date du jour au format YYYY_MM_Mois
current_month_year="$(LC_TIME=fr_FR.UTF-8 date +%Y_%m_%B)"

# Définit le chemin du dossier pour le mois et l'année en cours dans l'archive
current_month_year_folder="${archive_path}/${current_month_year}"

# Crée le dossier pour le mois et l'année en cours s'il n'existe pas
mkdir -p "${current_month_year_folder}"

# Boucle sur tous les fichiers du bureau
for file in "${desktop_path}"/*; do

  # Récupère les tags du fichier (si possible)
  tags=$(mdls -name kMDItemUserTags -raw "${file}")

  # Si le fichier a des tags
  if [ -n "${tags}" ]; then

    # Si le tag "Bureau" n'est pas présent
    if [[ ! "${tags}" =~ "Bureau" ]]; then

      # Détermine le chemin de destination du fichier
      destination="${current_month_year_folder}/$(basename "${file}")"

      # Si un fichier avec le même nom existe déjà à destination
      if [ -e "${destination}" ]; then

        # Déplace le fichier avec confirmation
        mv -i "${file}" "${destination}"

      else

        # Déplace le fichier sans confirmation
        mv "${file}" "${destination}"

      fi

    fi

  # Si le fichier n'a pas de tags ou le tag "Bureau"
  else

    # Détermine le chemin de destination du fichier
    destination="${current_month_year_folder}/$(basename "${file}")"

    # Si un fichier avec le même nom existe déjà à destination
    if [ -e "${destination}" ]; then

      # Déplace le fichier avec confirmation
      mv -i "${file}" "${destination}"

    else

      # Déplace le fichier sans confirmation
      mv "${file}" "${destination}"

    fi

  fi

done
