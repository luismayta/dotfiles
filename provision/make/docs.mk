#
# See ./CONTRIBUTING.rst
#

FILE_README=$(ROOT_DIR)/README.rst

docs:
	make docs.help

docs.help:
	@echo '    Docs:'
	@echo ''
	@echo '        docs.show                  Show restview README'
	@echo '        docs.make                  Make documentation html'
	@echo ''

docs.show: clean
	restview "${FILE_README}"

docs.make: clean
	$(docker-compose) -f ${PATH_DOCKER_COMPOSE}/dev.yml run --rm docs bash -c "cd docs && make html"
