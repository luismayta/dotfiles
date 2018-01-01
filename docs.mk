#
# See ./CONTRIBUTING.rst
#

FILE_README=$(ROOT_DIR)/README.rst

docs.help:
	@echo '    Docs:'
	@echo ''
	@echo '        docs.show                  Show restview README'
	@echo '        docs.make.html             Make documentation html'
	@echo ''

docs.show: clean
	restview "${FILE_README}"

docs.make.html: clean
	docker-compose run --rm docs bash -c "cd docs && make html"

docs.make.pdf: clean
	docker-compose run --rm docs bash -c "cd docs && make latexpdf"
