function jwtdecode -a token -d "decode jwt token"
    if test $token = -
        read token
    end

    for part in (string split "." (string trim $token))
        set partlen (string length -V $part)
        if test (math "$partlen % 4") -ne 0
            set part (string pad --right -c '=' -w (math "$partlen + (4 - $partlen % 4)") $part)
        end

        set parsed (echo $part | base64 -d)
        if string match -q -r '^\{' $parsed
            echo $parsed | jq .
        end
    end
end
