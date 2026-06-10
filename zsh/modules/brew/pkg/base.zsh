# shellcheck shell=bash
function brew::load {
    export PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
    export PATH="${HOME}/.linuxbrew/bin:${PATH}"
    case "${OSTYPE}" in
      darwin*) ;;
      linux*)
        case $DIST in
          RedHat | Redhat | Debian | "")
            if [ -d /home/linuxbrew/.linuxbrew ]; then
              export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
              export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
            elif [ -d ~/.linuxbrew ]; then
              export MANPATH="${HOME}"/.linuxbrew/share/man:$MANPATH
              export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
              export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
            fi
            ;;
          Ubuntu)
            case $DIST_VERSION in
              12.04 | 14.04)
                if [ -d /home/linuxbrew/.linuxbrew ]; then
                  export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
                elif [ -d ~/.linuxbrew ]; then
                  export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
                fi
                ;;
              16.04 | 18.04)
                if [ -d /home/linuxbrew/.linuxbrew ]; then
                  export MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH
                elif [ -d ~/.linuxbrew ]; then
                  export MANPATH=$HOME/.linuxbrew/share/man:$MANPATH
                  export INFOPATH=$HOME/.linuxbrew/share/info:$INFOPATH
                  export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH
                fi
                ;;
            esac
            ;;
        esac
        ;;
    esac
}

# Auto-invoke load on module source
brew::load

# Auto-install if brew not found
if ! type -p brew > /dev/null; then
    brew::install
    brew::post_install
fi
