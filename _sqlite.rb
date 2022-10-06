require 'sqlite3'

@file = 'basa.sqlite'
@tab_users = 'Users'
@tab_conts = 'Contacts'
@time = Time.now.strftime('%Y-%m-%d %H:%M')

def tab_create
  SQLite3::Database.new @file do |db|
    db.execute("CREATE TABLE IF NOT EXISTS #{@tab_users}
                  (Id INTEGER PRIMARY KEY AUTOINCREMENT,
                    Name varchar,
                    Phone varchar,
                    DateStamp varchar,
                    Barber varchar,
                    Color varchar)
                ")

    db.execute("CREATE TABLE IF NOT EXISTS #{@tab_conts}
                  (Id INTEGER PRIMARY KEY AUTOINCREMENT,
                    Email varchar,
                    Message varchar,
                    DateStamp varchar)
                ")
  end
end

def tab_add
  SQLite3::Database.new @file do |db|
    db.execute("REPLACE INTO #{@tab_users} (Name, Phone, DateStamp, Barber, Color)
                 VALUES
                      ('Николай1',  '+7(999) 666 44-22', '#{@time}', 'Bareber_name1', 'Color_name1'),
                      ('Дудь1',     '+7(999) 666 11-88', '#{@time}', 'Bareber_name2', 'Color_name2'),
                      ('Максим1',   '+7(999) 666 00-00', '#{@time}', 'Bareber_name3', 'Color_name3')
                ")
  end

  SQLite3::Database.new @file do |db|
    db.execute("REPLACE INTO #{@tab_conts} (Email, Message, DateStamp)
                 VALUES
                      ('mail@mail.ru',      'Текст сообщения 11',                        '#{@time}'),
                      ('google@gmail.com',  'Текст сообщения еще куча слов и текста 22', '#{@time}')
                ")
  end
end

def tab_read
  SQLite3::Database.new @file do |db|
    db.execute "SELECT * FROM #{@tab_conts}" do |tab|
      pp tab
    end

    db.execute "SELECT * FROM #{@tab_users}" do |tab|
      pp tab
    end
  end
end

tab_create
tab_add
tab_read