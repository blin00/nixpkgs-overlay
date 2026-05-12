user="$1"
group="$2"
perm="$3"
src="$4"
tgt="$5"

if [ -z "$user" ] || [ -z "$group" ] || [ -z "$perm" ] || [ -z "$src" ] || [ -z "$tgt" ]; then
    exit 1
fi

tgt_dir=$(dirname "$tgt")

# 1. Create a temporary directory on the target's filesystem
tmp_dir=$(mktemp -d "$tgt_dir/.tmp.XXXXXXXXXX") || exit 1
tmp_file="$tmp_dir/$(basename "$tgt")"

# 2. Copy the source without dereferencing (-P)
# 3. Set owner and group without dereferencing (-h)
# If either fails, clean up the temp directory and abort
cp -P "$src" "$tmp_file" && chown -h "$user:$group" "$tmp_file" || { rm -rf "$tmp_dir"; exit 1; }

# 4. Set permissions (Skip if it's a symlink)
if [ ! -h "$tmp_file" ]; then
    chmod "$perm" "$tmp_file" || { rm -rf "$tmp_dir"; exit 1; }
fi

# 5. Move into place atomically
mv --no-target-directory "$tmp_file" "$tgt" || { rm -rf "$tmp_dir"; exit 1; }

# 6. Clean up
rm -rf "$tmp_dir"
