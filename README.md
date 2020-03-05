Fork of muallin's YACReaderLibraryServer Docker to download the 'develop' branch of YACReader. 

HOW TO
===
```
1.  docker run -d -p <port>:8080 -v <comics folder>:/comics --name=yacserver xthursdayx/yacreaderlibrary-server-docker
2a. docker exec yacserver YACReaderLibraryServer create-library <library-name> /comics
or
2b. docker exec yacserver YACReaderLibraryServer add-library <library-name> /comics
3.  docker exec yacserver YACReaderLibraryServer update-library /comics
4.  docker exec yacserver YACReaderLibraryServer list-libraries
5.  docker exec yacserver YACReaderLibraryServer remove-library <library-name>
```
