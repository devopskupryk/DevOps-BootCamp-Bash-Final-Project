#!/bin/bash

currentVersion="1.23.0"
help="Bash tool to transfer files from the command line.
Usage:
  -d  <outputfilename> <foldername> <filename> download file
  -h  Show the help  
  -v  Get the tool version
Examples:
  upload file: ./transfer.sh test.txt
  dowmload file: ./transfer.sh -d ./test XYk2Br test.txt"

httpSingleUpload()
{
    response=$(curl -A curl --progress-bar --upload-file "$1" "https://transfer.sh/$1") || { echo "Failure!"; return 1;}
}

printUploadResponse()
{
  #fileID=$(echo "$response" | cut -d "/" -f 4)
  cat <<EOF
    Transfer File URL: $response
EOF
}

singleUpload()
{
  filePath="${i//~/$HOME}"
  echo "$filePath"
  if [[ ! -f "$filePath" ]]; then { echo "Error: invalid file path"; return 1;}; fi
  tempFileName=$(echo "$filePath" | sed "s/.*\///")
  echo "Uploading $tempFileName"
  httpSingleUpload "$tempFileName"
}

singleDowload()
{
    echo "Downloading $3"
    #response=$(curl --progress-bar -o "$3" "https://transfer.sh/$2/$3" --output-dir ./"$1") || { echo "Failure!"; return 1;}      
    if [[ -d "$1" ]]; then
      response=$(curl --progress-bar --output-dir ./"$1" -o "$3" "https://transfer.sh/$2/$3") || { echo "Failure!"; return 1;}      
    else
      echo "Error: invalid file path" 
      return 1
    fi
}

printDownloadResponse() 
{
  if [[ $? == 0 ]]; then
    echo "Success!"
  fi
}

case "$1" in
  "-v" ) echo "$currentVersion";;
  "-h" ) echo "$help";;
  "-d" ) 
    singleDowload "$2" "$3" "$4"  
    printDownloadResponse
    ;;
  * )
    for i in "$@"; do
      singleUpload "$i" || exit 1
      printUploadResponse 
    done
    ;;
esac