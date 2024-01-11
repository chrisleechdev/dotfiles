# Pipe into this function to strip newlines. Useful for editing JSON in a text
# editor before using it in the CLI, for example:
# pbpaste | stripnewlines | pbcopy
stripnewlines() {
    while read data; do
        echo $data | tr -d '\n' | tr -s ' '
    done
}

