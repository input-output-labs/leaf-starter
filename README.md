#LS4T - Escape Coding Game - Webapp

Developped in Sophia Antipolis.

##About
###About
###Contact


##Build the APP

####Build for Java
`$ mvn install`

####Build for Docker
`$ ./dockerize.sh`

##Start the APP

####Start with Java
*Prerequisite:*  mongo is started on port 27017

`$ java -jar back-end/target/escape-1.0.0-SNAPSHOT.jar`

####Start with Docker
First, start mongoDB on Docker:
`$ docker run --name mongo -d mongo`

Then, start the app:
`$ docker create -p <PORT>:8080 --link mongo ls4t/escape`

###Features

- Feature 1
- Feature 2
