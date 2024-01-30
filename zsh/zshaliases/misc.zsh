alias watch="watch "

gif() {
    # Based on https://gist.github.com/SheldonWangRJT/8d3f44a35c8d1386a396b9b49b43c385
    output_file="$1.gif"
    ffmpeg -y -i $1 -v quiet -vf scale=iw/2:ih/2 -pix_fmt rgb8 -r 10 $output_file && gifsicle -O3 $output_file -o $output_file
}

function v2g() {
    # Based on https://gist.github.com/mcmoe/c76895ee86bd5293d58aca7a75afb6b2
    src="" # required
    target="" # optional (defaults to source file name)
    resolution="" # optional (defaults to source video resolution)
    fps=10 # optional (defaults to 10 fps -- helps drop frames)

    while [ $# -gt 0 ]; do
        if [[ $1 == *"--"* ]]; then
                param="${1/--/}"
                declare $param="$2"
        fi
        shift
    done

    if [[ -z $src ]]; then
        echo -e "\nPlease call 'v2g --src <source video file>' to run this command\n"
        return 1
    fi

    if [[ -z $target ]]; then
        target=$src
    fi

    basename=${target%.*}
    [[ ${#basename} = 0 ]] && basename=$target
    target="$basename.gif"

    if [[ -n $fps ]]; then
        fps="-r $fps"
    fi

    if [[ -n $resolution ]]; then
        resolution="-s $resolution"
    fi

    runcommand="ffmpeg -i "$src" -pix_fmt rgb8 $fps $resolution "$target" && gifsicle -O3 "$target" -o "$target""

    echo ""
    echo ".------------------------."
    echo "|\\\\////////       90 min |"
    echo "| \\/  __  ______  __     |"
    echo "|    /  \|\.....|/  \    |"
    echo "|    \__/|/_____|\__/    |"
    echo "| A                      |"
    echo "|    ________________    |"
    echo "|___/_._o________o_._\___|"
    echo ""
    echo "ツ running >> $runcommand"
    echo "ツ ..."
    echo ""

    eval " $runcommand"
    osascript -e "display notification \"$target successfully converted and saved\" with title \"v2g complete\""
}
