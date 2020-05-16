#
# See ./CONTRIBUTING.rst
#
.PHONY: keybase.help

keybase.help:
	@echo '    keybase:'
	@echo ''
	@echo '        keybase                      help keybase'
	@echo '        keybase.setup                Setup dependences for keybase'
	@echo ''

keybase:
	make keybase.help

keybase.setup:
	@echo "=====> make dependences for ${TEAM}..."
	mkdir -p ${KEYBASE_PROJECT_PATH}/{staging,prod,dev}/{pem,private,password,pub,openssl}
	@echo ${MESSAGE_HAPPY}
