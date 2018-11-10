# build and run a new docker image of the database
# usage: sh scripts/build-run.sh

export build=el-dorado-`jot -r 1 100 999`
echo $build

sleep 2
rm -r csv
cp -rp ../el-dorado-et/csv csv
docker build -t $build .

sleep 2
docker ps | grep 7474 | while read c i x; do
	docker stop $c
	docker rm $c
	docker rmi $i
done

sleep 2
docker run -d -p 7474:7474 -p 7473:7473 -p 7687:7687 $build

sleep 2
docker ps -a