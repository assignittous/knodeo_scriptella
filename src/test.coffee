console.log "TEST"

scriptella = require("./index").Scriptella

propertiesTest = 
  databases:
    drivers:
      postgresql:
        class: "org.postgresql.Driver"
        classPath: "{{cwd}}/_workshop/drivers/postgresql-9.3-1103.jdbc4.jar"
        baseUrl: "jdbc:postgresql://{{something}}"
    mydb:
      development:
        driver: "postgresql"        
        host: "localhost"
        port: 5432
        database: "mydb"        
        user: "user"
        password: "password"
      staging:
        driver: "postgresql"
        host: "localhost"
        port: 5432
        database: "mydb"            
        user: "user"
        password: "password"
      production:
        driver: "postgresql"
        host: "localhost"
        port: 5432
        database: "mydb"            
        user: "user"
        password: "password"

scriptella.testMode = true


locals = 
  cwd: ()->
    return process.cwd()
  something: "something!!244"

# scriptella.writeProperties "etl.properties", properties, locals

scriptella.execute "e:\\Staging\\test.xml", propertiesTest, locals