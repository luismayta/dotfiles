#
# See ./CONTRIBUTING.rst
#
.PHONY: utils.help

utils.help:
	@echo '    utils:'
	@echo ''
	@echo '        utils                      help utils'
	@echo '        utils.generate             generate key ssh by stage'
	@echo ''

utils:
	make utils.help

utils.generate:
	mkdir -p ${KEYBASE_PROJECT_PATH}/${stage}/{pem,pub,private,openssl}
	mkdir -p ${KEYBASE_PROJECT_PATH}/${stage}/pub
	mkdir -p ${KEYBASE_PROJECT_PATH}/${stage}/private
	mkdir -p ${KEYBASE_PROJECT_PATH}/${stage}/openssl

	ssh-keygen -q -m PEM -t rsa -b 4096 -C "admin@${PROJECT}-${stage}.com" -f ${PROJECT}-${stage} -P ""
	openssl rsa -in ${PROJECT}-${stage} -outform pem > ${PROJECT}-${stage}.pem
	chmod 0600 ${PROJECT}-${stage}.pem
	cp -rf ${PROJECT}-${stage}.pem ${KEYBASE_PROJECT_PATH}/${stage}/pem/
	cp -rf ${PROJECT}-${stage}.pub ${KEYBASE_PROJECT_PATH}/${stage}/pub/
	cp -rf ${PROJECT}-${stage} ${KEYBASE_PROJECT_PATH}/${stage}/private/
