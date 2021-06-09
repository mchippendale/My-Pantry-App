
require 'pg'

def run_sql(sql, params = [])

    db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'mypantry'})

    

    # PG.connect(dbname: 'goodfoodhunting')
    # db exec_params("selec * from dishes where id = $1", [params["id"]])
    # res = db.exec(sql)
    res = db.exec_params(sql, params)
    
    db.close

    return res
  
end