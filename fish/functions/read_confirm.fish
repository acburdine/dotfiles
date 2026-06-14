# https://stackoverflow.com/a/36523501
function read_confirm --argument prompt
    set -q prompt; or set prompt -l "Confirm?"

    while read -n 1 -l response --prompt-str "$prompt (Y/n)" or return 1
        switch "$response"
            case y Y
                return 0
            case n N
                return 1
            case '*'
                echo "Please answer Y or n."
                continue
        end
    end
end
