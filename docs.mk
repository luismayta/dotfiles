#
# See ./CONTRIBUTING.rst
#

docs.show: clean
	@make clean
	restview "${FILE_README}"

docs.make.html: clean
	docker-compose run --rm docs bash -c "cd docs && make html"

docs.make.pdf: clean
	docker-compose run --rm docs bash -c "cd docs && make latexpdf"