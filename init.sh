#!/bin/bash

function clone_repos () {
	mkdir tmp

	cd tmp

	git clone https://github.com/input-output-labs/leaf.git
	git clone https://github.com/input-output-labs/ngleaf.git

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
sed -i 's/ngleaf\/webapp/'$1'\/webapp/g' front-end/package.json
replace_in_file front-end/angular.json 'ngleaf-app' $1'-app'
replace_in_file front-end/src/index.html 'NgleafApp' $1
replace_in_file front-end/src/environments/environment.prod.ts 'leafdemo' $1

cd front-end
npm install @iolabs/ngleaf --save --force
cd ..

echo '********* Copying back-end *********'

copy_back

replace_in_file back-end/pom.xml 'leaf-demo' $1
replace_in_file back-end/pom.xml 'ngleaf-app' $1'-app'

echo '********* Testing installation *********'
mvn install

echo
echo
echo
echo
echo "Setup Completed"
echo "Run the app with \"java -jar back-end/target/"$1"-0.0.10-SNAPSHOT.jar\""
echo
echo
echo
echo "First launch may failed. Try it twice (#AY method):)"
