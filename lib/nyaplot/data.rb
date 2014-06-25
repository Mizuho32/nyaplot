require 'nyaplot'
require 'securerandom'
require 'json'

module Nyaplot
  class DataFrame
    def initialize(source, name=SecureRandom.uuid())
      @name = name
      @rows = []
      case
      when source.is_a?(Array)
        # like [{a:10, b:10},{a:20,b:20}]
        @rows = source
      when source.is_a?(Hash)
        # like {a:[10,20], b:[10, 20]}
        keys = source.keys
        len = source[keys[0]].length
        (0..len-1).each do |i|
          hash = {}
          keys.each{|key| hash[key] = source[key][i]}
          @rows.push(hash)
        end
      end
    end

    def insert_column(name, arr)
      arr.each_with_index{|val| @rows[i][name]=val}
    end

    def column(name)
      column = []
      @rows.each{|row| column.push(row[name])}
      return column
    end

    def insert_row(row, index=@rows.length)
      @rows.insert(index, row)
    end

    def row(index)
      @rows[index]
    end

    def to_json()
      @rows.to_json
    end

    def to_html()
      html = '<table><tr>'
      @rows[0].each {|key, val| html.concat('<th>' + key.to_s + '</th>')}
      html += '</tr>'
      @rows.each do |row|
        html += '<tr>'
        row.each{|val| html.concat('<td>' + val.to_s + '</td>')}
        html += '</tr>'
      end
      html += '</table>'
    end

    def method_missing(name, *args)
      if md = name.match(/(*+)=/)
        self.insert_column(md[1], args[0])
        return
      else
        return self.column(args[0])
      end
    end
  end
end
