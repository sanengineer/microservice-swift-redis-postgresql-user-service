# Server Side Swift With Postgres and Redis For Create User Services As Microservices

On almost engineer just strating, swift  familliar running on apple device on client-side. But since apple build SwiftNIO, swift unlock capability can running on server-side. In this project I try use vapor, postgres, and redis to create user services as microservices. vapor is web framework for server-side swift, and build on top of SwiftNIO.

## RestAPI Endpoint URL

### Read

read all user:

    /user
    
read on user:

    /user/{id}
    
### Create

create user or register user:

    /user/auth/register


login user:

    /user/auth/login
    
this auth used **Basic Auth**, which encode `username` and `password` as paylod to` base64 encode` and used **Bearer Auth**.
