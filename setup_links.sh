#!/bin/zsh

echo "This is not working yet"
return

setopt nullglob

echo "Setting up links in \$HOME"
for dir in */; do 
    echo "Parsing $dir"
    for file_path in "$dir"**/*(.) "$dir"**/.[^.]*(.); do
        relative_path="${file_path#"$dir"}"
        echo "  > $relative_path"
        if [[ -L $HOME/$relative_path ]]; then
            echo "SKIPPING: $HOME/$relative_path is already a symlink. Remove manually."
            continue
        fi
        if [[ -s $HOME/$file_path ]]; then
            echo "$HOME/$file_path exists and is not empty"
            #mv $HOME/$relative_path $HOME/$relative_path.old 
        fi
        stow -v $file_path -n
    done
done

echo "Setting up links in \$HOME/.config"
for dir in .config/*/; do
    echo $dir
done
unsetopt nullglob
