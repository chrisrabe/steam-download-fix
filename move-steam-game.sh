#!/bin/bash

read -p "Enter external drive location: " EXTERNAL_DRIVE_LOCATION
read -p "Enter internal drive location: " INTERNAL_DRIVE_LOCATION

echo

function printGamesOnDrive() {
    echo "List of available games in external drive:"
    games=$(ls "${EXTERNAL_DRIVE_LOCATION}/common")
    for game in "${games[@]}"
    do
        echo "${game}"
    done
}

printGamesOnDrive
echo

read -p "Please enter the game you want to move: " GAME_LIBRARY

function getManifest() {
    local game="$1"
    manifests=($(ls ${EXTERNAL_DRIVE_LOCATION} | grep .acf))
    for manifest in "${manifests[@]}"
    do
        is_manifest=$(cat "${EXTERNAL_DRIVE_LOCATION}/${manifest}" | grep installdir | sed -e s'/^[[:space:]]*//' | grep ${game})
        if [ ! -z "${is_manifest}" ]
        then
            echo "${manifest}"
            break
        fi
    done
}

manifest=$(getManifest "$GAME_LIBRARY")

if [ -z "${manifest}" ]
then
    echo "Manifest not found. Please ensure that the game folder is correct."
    exit 1
fi

echo
echo "Moving $manifest..."
mv "${EXTERNAL_DRIVE_LOCATION}/${manifest}" "${INTERNAL_DRIVE_LOCATION}"

echo
echo "Moving ${GAME_LIBRARY} directory (this may take a few minutes depending on the game size)"

INTERNAL_COMMON_DIR="${INTERNAL_DRIVE_LOCATION}/common"
EXTERNAL_COMMON_DIR="${EXTERNAL_DRIVE_LOCATION}/common"
mkdir -p "${INTERNAL_COMMON_DIR}"
mv "${EXTERNAL_COMMON_DIR}/${GAME_LIBRARY}" "${INTERNAL_COMMON_DIR}"

echo "Done"
echo "Next steps:"
echo "- Re-open Steam"
echo "- Update the game via the Steam client"
echo "- Move the game from your internal drive to the external drive"
