require 'sqlite3'

@file = 'basa.sqlite'
@tab_users = 'Users'
@tab_conts = 'Contacts'
@time = Time.now.strftime('%Y-%m-%d %H:%M')

def create
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

def add_users
  SQLite3::Database.new @file do |db|
    db.execute("INSERT INTO #{@tab_users} (Name, Phone, DateStamp, Barber, Color)
                 VALUES
                      ('Николай1',  '+7(999) 666 44-22', '#{@time}', 'Bareber_name1', 'Color_name1'),
                      ('Дудь1',     '+7(999) 666 11-88', '#{@time}', 'Bareber_name2', 'Color_name2'),
                      ('Максим1',   '+7(999) 666 00-00', '#{@time}', 'Bareber_name3', 'Color_name3')
                ")
  end
end

def add_contacts
  SQLite3::Database.new @file do |db|
    db.execute("INSERT INTO #{@tab_conts} (Email, Message, DateStamp)
                 VALUES
                      ('mail@mail.ru',      'Текст сообщения 11',                        '#{@time}'),
                      ('google@gmail.com',  'Текст сообщения еще куча слов и текста 22', '#{@time}')
                ")
  end
end

create
add_users
add_contacts
