VERSION=9.3.0
DUMPFILE=latest-truthy.nt.gz

free:
	docker build --no-cache --pull --build-arg edition=free --build-arg version=${VERSION} --build-arg DUMPFILE=${DUMPFILE} -t redadmiral/graphdb_wikidata:${VERSION} .

