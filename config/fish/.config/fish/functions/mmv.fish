function mmv
    set destination (fd -t d | fzf --header="Select destination directory:")
    if test -n "$destination"
        set -l selected_files (fd -t f | fzf -m --header="Select files to move:")
        if test -n selected_files
            mv $selected_files $destination
            echo "Moved files to $destination"
        else
            echo "No files selected!"
        end
    else
        echo "No destination selected!"
    end
end
