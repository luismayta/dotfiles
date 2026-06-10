#
# Docker CLI wrappers
#

awscli() {
  docker run --rm -it \
    -v "$(pwd):/home/nikovirtala" \
    -v "${HOME}/.aws:/home/nikovirtala/.aws" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    nikovirtala/awscli:latest "$@"
}

aws-shell() {
  docker run --rm -it \
    -v "$(pwd):/home/nikovirtala" \
    -v "${HOME}/.aws:/home/nikovirtala/.aws" \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    nikovirtala/aws-shell:latest "$@"
}

nyancat() {
  docker run -it --rm supertest2014/nyan
}

ytd-mp3() {
  docker run --rm -v "${PWD}":/data hadenlabs/youtube-dl --extract-audio --audio-format mp3 "$@"
}

ytdl() {
  docker run --rm -v "${PWD}":/data hadenlabs/youtube-dl "$@"
}

youtube-dl() {
  docker run --rm -v "${PWD}":/data hadenlabs/youtube-dl "$@"
}

komiser() {
  docker run --rm -d -p 3000:3000 \
    -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
    -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
    -e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
    --name komiser mlabouardy/komiser:2.4.0
}
