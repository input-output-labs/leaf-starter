#!/bin/bash

function clone_repos () {
	mkdir tmp

	cd tmp

	git clone http://gitlab.io-labs.fr:12001/io-labs/leaf.git
	git clone http://gitlab.io-labs.fr:12001/io-labs/ngleaf.git

	cd ..
}

function copy_back () {
	mkdir back-end
	cp -r tmp/leaf/demo/* back-end/.
}

function copy_front () {
	mkdir front-end
	cp -r tmp/ngleaf/* front-end/.
	rm -r front-end/projects
}

function replace_in_file () {
	sed -i 's/'$2'/'$3'/g' $1
}

if [ -z "$1" ]; then
  echo 'The app name is missing'
  exit 1
fi

echo '********* BUILDING '$1' *********'

if [  ! -d "tmp" ]; then
  echo '********* Cloning repositories *********'
  clone_repos
fi

echo '********* Copying project configuration *********'
cp _pom.xml pom.xml
cp _dockerize.sh dockerize.sh
cp _Dockerfile Dockerfile

replace_in_file pom.xml '\[\[artifactId\]\]' $1
replace_in_file dockerize.sh '\[\[artifactId\]\]' $1
replace_in_file Dockerfile '\[\[artifactId\]\]' $1

echo '********* Copying front-end *********'
copy_front

cp _pom_frontend.xml front-end/pom.xml
cp _npmrc front-end/.npmrc

replace_in_file front-end/pom.xml '\[\[artifactId\]\]' $1
replace_in_file front-end/package.json 'ngleaf-app' $1'-app'
replace_in_file front-end/src/index.html 'NgleafApp' $1

echo '********* Copying back-end *********'

copy_back

replace_in_file back-end/pom.xml 'leaf-demo' $1
replace_in_file back-end/pom.xml 'leaf-demo' $1
replace_in_file back-end/src/main/resources/application.properties 'leafdemo' $1

echo '********* Testing installation *********'
# mvn install

echo
echo
echo
echo
echo "Please add @iolabs/ngleaf dependeny manually to front-end/package.json then run mvn install here"

# rm -r tmp


