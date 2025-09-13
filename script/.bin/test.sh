#!/bin/bash

# set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    exit 1
fi

SCRIPT_NAME="${0##*/}"

die() {
    local message=$1
    local exit_code=${2:-1}
    echo "$message" >&2
    echo "Try using -h, -? or --help to print help message."
    exit "$exit_code"
}

usage() {
    cat<<EOF
USAGE:
    $SCRIPT_NAME [OPTIONS] [PARAMETERS] [--] [ARGUMENTS] [OPTIONALS]

ARGUMENTS:
        - [ip] the script need at least a valid ip address to work.

[OPTIONALS]:
        - [url] if no url is given the script default to the current dir name and ask for TDL.

OPTIONS:
        -d, --delete-entry:
            Remove an entry with regexp.
        -h, --help:
            Print this message.
        -i, --ip:
            Set or replace the ip for the entry. Require a valid IP.
        -m, --modify-entry:
            TODO
        -r, --replace-entry:
            TODO
        -u, --url:
            Set or replace the url for the entry. Require a url name for /etc/hosts.
        -v, --verbose:
            I'm not sure.
EOF
}

# Initialize all the option variables.
# Using at the top ensures that we are not contaminated by variables from the environment.
file=
verbose=0
# Initialize a flag array to store flag to handle multiple options.
flags=()

while :; do
    case $1 in
        -d|--delete-entry)
            if [ "$2" ]; then
                flags+=("del")
                del_entry=$2
                shift
            else
                die 'ERROR: "-d" or "delete-entry" requires a valid ip or url as an option arguement.' 2
            fi
            ;;
        --delete-entry=?*)
            flags+=("delete")
            regex_pattern=${1#*=}
            ;;
        --delete-entry=)
            die 'ERROR: "--delete-entry=" requires a valid ip as an option argument.' 2
            ;;
        -h|-\?|--help)
            flags+=("help")
            usage
            ;;
        -i|--ip)
            flags=("ip")
            if [ "$2" ]; then
                ip=$2
                shift
            else
                die 'ERROR: "-i" or "--ip" requires a valid ip as an option argument.' 2
            fi
            ;;
        --ip=?*)
            flags+=("ip")
            ip=${1#*=}
            ;;
        --ip=)
            die 'ERROR: "--ip=" requires a valid ip as an option argument.' 2
            ;;
        --m|--modify-entry)
            # TODO
            ;;
        --modify-entry=?*)
            # TODO
            ;;
        --modify-entry=)
            # TODO
            ;;
        --r|--replace-entry)
            # TODO
            ;;
        --mod=?*)
            # TODO
            ;;
        --mod=)
            # TODO
            ;;
        -u|--url)
            if [ "$2" ]; then
                flags+=("url")
                url=$2
                shift
            else
                die 'ERROR: "-u" or "--url" requires a non-empty option argument.' 2
            fi
            ;;
        --url=?*)
            flags+=("url")
            url=${1#*=}
            ;;
        --url=)
            die 'ERROR: "--url=" requires a valid non-empty option argument.' 2
            ;;
        -v|--verbose)
            flag="verbose"
            verbose=$((verbose + 1))
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac
    shift
done

ip=$1
url=$2
HOST_FILE=/etc/hosts
DUPLI="$(grep -c -e "$domain" "$HOST_FILE")"
EMPTY_LINES="$(grep -c -e "^[[:space:]]*$" "$HOST_FILE")"
DIR_PATH="$(pwd)"

DIR_NAME="${DIR_PATH##*/}"
IPV4_REGEX="^([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$"

# if there is no dns specified default to dir name + .htb
if [[ $flag =~ "url" ]]; then
    domain=$url
else
    echo -n "Which Top Domain Level do you want to use?: "
    read -r tdl
    domain="${DIR_NAME}.${tdl}"
fi

validate_ipv4() {
    local ip=$1
    local IFS="."
    local parts=($ip)

    # check if there is exactly 4 parts
    if [ "${#parts[@]}" -ne 4 ]; then
        return 1
    fi

    for part in "${parts[@]}"; do
        # Check if each part is a number
        if ! [[ $part =~ ^[0-9]+$ ]]; then
            return 1
        fi

        # Check if each part is in the valid range (0-255)
        if [[ $part -lt 0 || $part -gt 255 ]]; then
            return 1
        fi

    done

    # if everything is ok return 0 for 0K
    return 0
}

validate_hostfile_url() {
    local url="$1"
    local url_regex="^[a-zA-Z0-9.-]+$"

    if [[ $url =~ $url_regex ]]; then
        return 0
    else
        return 1
    fi
}



list_ips_and_urls() {
    # list all entries in hosts except local addresses
    grep -E "^$IPV4_REGEX" "$HOST_FILE" | grep -vE "local(host|domain)" | grep -vE "192\.168\.1.*"
}


remove_empty_line() {
    # awk 'NF' "$HOST_FILE" &> /dev/null
    if [ "$EMPTY_LINES" -ne 0 ]; then
        sed --in-place --regexp-extended '/^[[:space:]]*$/d' "$HOST_FILE"
    fi
}

remove_duplicate_domain() {
    count=$(grep --count --regexp "$domain.*$" "$HOST_FILE")
    if [[ "$count" -gt 1 ]]; then
        sed --in-place --regexp-extended "/$domain.*$/d" "$HOST_FILE"
    else
        return 1
    fi
}

remove_pattern() {
    if [[ "$flag" =~ "delete" ]]; then
        sed --in-place --regexp-extended "/$regex_pattern/d" "$HOST_FILE"
    fi
}

add_entry() {
    echo "${ip} ${url}" | tee -a /etc/hosts > /dev/null
}

del_entry() {
    #TODO
    if validate_ipv4 "$@"; then
        sed --in-place --regexp-extended "/$1/d" "$HOST_FILE"
        remove_empty_line
    elif validate_hostfile_url "$@"; then
        sed --in-place --regexp-extended "/$1/d" "$HOST_FILE"
        remove_empty_line
    else
        die 'ERROR: "-d" or "delete-entry" requires a valid ip or url as an option arguement.' 2
    fi
}

mod_entry() {
    # TODO
    exit 0
}

replace_entry() {
    # TODO
    exit 0
}

check_for_duplicates() {
    for arg in "${@}"; do
        local count=''
        count=$(grep --count --regexp "^.*$arg.*$" "$HOST_FILE")
        if [[ $count -gt 0 ]]; then
            del_entry "$arg"
        fi
    done
}


# main part of the script
if [[ -z $flag && $# -eq 0 ]]; then
    usage
    exit 1
elif [[ -n $ip && -n $url ]]; then
    if validate_ipv4 "$@" && validate_hostfile_url "$@"; then
        add_entry
    fi
elif [[ -z $url ]]; then
    if validate_ipv4 "$@"; then
        add_entry
    fi
fi

# set +x
