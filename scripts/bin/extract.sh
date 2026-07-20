# Based on @NotAShelf's extract script
extract() {
  if [ $# -eq 0 ]; then
    echo "Usage: extract <archive> [archive ...]" >&2
    echo "Each archive is unpacked into a directory named after the file." >&2
    return 1
  fi

  local n abs base target i rc=0

  for n in "$@"; do
    if [ ! -f "$n" ]; then
      echo "extract: '$n' - file doesn't exist" >&2
      rc=1
      continue
    fi

    # Absolute path to the archive, so tools can run from inside the target dir
    abs=$(cd "$(dirname -- "$n")" && pwd)/$(basename -- "$n")
    base=$(basename -- "$n")

    # Directory name = file name minus its archive extension(s)
    case "$base" in
    *.tar.bz2 | *.tar.gz | *.tar.xz | *.tar.zst) target=${base%.tar.*} ;;
    *.*) target=${base%.*} ;;
    *) target=${base}.extracted ;;
    esac

    # Never clobber an existing file or directory
    if [ -e "$target" ]; then
      i=1
      while [ -e "${target}_$i" ]; do i=$((i + 1)); done
      target="${target}_$i"
    fi

    mkdir -p -- "$target" || {
      rc=1
      continue
    }
    echo "extract: '$n' -> '$target/'"

    case "$base" in
    *.cbt | *.tar.bz2 | *.tar.gz | *.tar.xz | *.tar.zst | *.tbz2 | *.tgz | *.txz | *.tar)
      tar xvf "$abs" -C "$target"
      ;; # tar auto-detects compression
    *.lzma) unlzma -c -- "$abs" >"$target/${base%.lzma}" ;;
    *.bz2) bunzip2 -c -- "$abs" >"$target/${base%.bz2}" ;;
    *.gz) gunzip -c -- "$abs" >"$target/${base%.gz}" ;;
    *.xz) unxz -c -- "$abs" >"$target/${base%.xz}" ;;
    *.z | *.Z) gunzip -c -- "$abs" >"$target/${base%.*}" ;;
    *.cbr | *.rar) unrar x -- "$abs" "$target/" ;;
    *.cbz | *.epub | *.zip | *.jar | *.whl) unzip -q -- "$abs" -d "$target" ;;
    *.7z | *.apk | *.arj | *.cab | *.cb7 | *.chm | *.deb | *.iso | *.lzh | *.msi | *.pkg | *.rpm | *.udf | *.wim | *.xar | *.vhd)
      7z x "$abs" -o"$target"
      ;;
    *.exe) cabextract -d "$target" -- "$abs" ;;
    *.cpio) (cd "$target" && cpio -idv <"$abs") ;;
    *.cba | *.ace) unace x "$abs" "$target/" ;;
    *.zpaq) zpaq x "$abs" -to "$target" ;;
    *.arc) (cd "$target" && arc e "$abs") ;;
    *.cso) ciso 0 "$abs" "$target/${base%.cso}.iso" ;;
    *.zlib) zlib-flate -uncompress <"$abs" >"$target/${base%.zlib}" ;;
    *.dmg) hdiutil attach -- "$abs" -mountpoint "$target" ;;
    *)
      echo "extract: '$n' - unknown archive type" >&2
      rmdir -- "$target" 2>/dev/null || true
      rc=1
      continue
      ;;
    esac || {
      echo "extract: '$n' - extraction failed" >&2
      rc=1
    }
  done

  return "$rc"
}
