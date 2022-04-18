#2022 Levi D. Smith - levidsmith.com 

require 'net/http'
require 'uri'
require 'socket'

require 'sqlite3'

class IpFinder
  attr_accessor :ipdb

  def initialize() 
    @ipdb = IpDB.new
#    find('https://levidsmith.com')

  end

  def find(strHost)
    strContent = Net::HTTP.get(URI.parse(strHost))

#    puts strContent

#    m = strContent.match(/<a.*href=\"(.*)\".*[^>]*>[^<]+<\/a>/)

#    m.captures.each do | capture |
#        puts capture
#    end

#    m = strContent.scan(/<a.*href=\"(.*)\".*[^>]*>[^<]+<\/a>/) 
    m = strContent.scan(/<a[^>]+href=\"(.*?)\"[^>]*>/) 

    m.each do | c |
        url = c[0]
#        puts "#{url}"
        if /.*\.[com|org|net|gov|io|uk]/.match(url)
            ipDomain = URI.parse(url).host
            begin
              ip = IPSocket::getaddress(ipDomain)
              @ipdb.addIp(ipDomain, ip)
            rescue SocketError
              false #domain doesn't exist
            end


#            puts ip
        end
#        puts "#{c[0]}"
    end

 
  end

  def getContent(strHost)
    #strContent = Net::HTTP.get(URI.parse(strHost))
#    s = TCPSocket.new "levidsmith.com", 443
#    strContent = ""
#    while line = strConent.gets
#      s += line
#    end
    uri = URI(strHost)
    res = Net::HTTP.get_response(uri)
    strContent = ""
    strContent += "CODE: " + res.code + "\n"
    strContent += "MESSAGE: " + res.message + "\n"
    strContent += "CLASS.NAME" + res.class.name + "\n"
    strContent += "BODY" + "\n"
    strContent += res.body

    return strContent

  end

  def printAllDomains()
    puts "Listing all domains"
    @ipdb.getAllDomains().each do | domain |
      puts domain
    end

  end

  def getAllDomains()
    return @ipdb.getAllDomains()
  end



end

class IpDB
    def initialize()
        db = SQLite3::Database.open 'test.db'
        db.execute "CREATE TABLE IF NOT EXISTS domain(name TEXT, ip TEXT, entered_timestamp TEXT, UNIQUE(name, ip));"
        #db.execute "ALTER TABLE domain ADD CONSTRAINT uniquecontstraint UNIQUE(name, ip)"
        
    end

    def addIp(strInDomain, strInIp)
        db = SQLite3::Database.open 'test.db'

#        results = db.query "SELECT name FROM domain WHERE name = ?", strInDomain

#        r1 = results.next
#        if (r1)
#            puts "#{r1['name']}"
#        end
#        puts db.get_first_value 'SELECT SQLITE_VERSION()'

#        puts db.get_first_value 'SELECT COUNT(*) FROM domain WHERE name = ?', strInDomain

        puts "#{strInDomain} = #{strInIp}"

         if ( (db.get_first_value 'SELECT COUNT(*) FROM domain WHERE name = ? and ip = ?', strInDomain, strInIp) == 0)
            db.execute "INSERT INTO domain (name, ip, entered_timestamp) VALUES (?, ?, CURRENT_TIMESTAMP)", strInDomain, strInIp

         end

        
#        if (result.next['c'].to_i == 0)

#            db.execute "INSERT INTO domain (name, ip) VALUES (?, ?)", strInDomain, strInIp
#        end
    end

    def getAllDomains() 
      listDomains = Array.new

      db = SQLite3::Database.open 'test.db'
      results = db.query "SELECT name, ip, entered_timestamp FROM domain ORDER BY name"
#      while(results.next)
#        puts "#{results['name']} = #{results['ip']} at #{results['entered_timestamp']}"
#        listDomains << "#{results['name']} = #{results['ip']} at #{results['entered_timestamp']}"
#        listDomains << "example.com"
#        listDomains << db.get_value
#      end
      results.each { | row |
#        listDomains << row['name']
        puts row.join(',')
        listDomains << row.join(',')

      }
      return listDomains

    end
end

#ipfinder = IpFinder.new
#ipfinder.find("levidsmith.com")

