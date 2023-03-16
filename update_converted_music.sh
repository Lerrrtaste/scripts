#!/usr/bin/env bash
trap "echo -e '\ncancled.'; exit 1" SIGINT SIGTERM

SOURCE_DIR="/home/lerrrtaste/annex/music/library"
DEST_DIR="/home/lerrrtaste/annex/music/library_converted"
mkdir -p "$DEST_DIR"

total_files=$(find -L "$SOURCE_DIR" -type f | wc -l)
current_file=0


find -L "$SOURCE_DIR" -type f -print0 | while IFS= read -r -d $'\0' full_path; do
  current_file=$((current_file + 1))
  file="${full_path#$SOURCE_DIR/}"
  dest_file="$DEST_DIR/$file"
  ext="${full_path##*.}"
  ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

  if [[ "$ext_lower" == "flac" || "$ext_lower" == "opus" ]]; then
    dest_file="${dest_file%.*}.mp3"
    mkdir -p "$(dirname "$dest_file")"
    if [[ ! -f "$dest_file" ]] || [[ "$full_path" -nt "$dest_file" ]]; then
      echo -ne "[$current_file/$total_files] Converting: $file\r"
      ffmpeg -nostdin -i "$full_path" -vn -acodec libmp3lame -q:a 4 -map_metadata 0 -id3v2_version 3 -write_id3v1 1 -y "$dest_file" > /dev/null 2>&1
    else
        echo -ne "[$current_file/$total_files] Skipping: $file\r"
    fi
  else
    echo "Unknown ending $ext, copying"
    mkdir -p "$(dirname "$dest_file")"
    if [[ ! -f "$dest_file" ]] || [[ "$full_path" -nt "$dest_file" ]]; then
      echo -ne "[$current_file/$total_files] Converting: $file\r"
      cp "$full_path" "$dest_file"
    else
      echo -ne "[$current_file/$total_files] Skipping: $file\r"
    fi
  fi
done

echo "Conversion complete."
