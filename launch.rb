#!/usr/bin/env ruby

=begin

proj/
    [src, _nodejs_]/
        .../
        public/
            images/
                *.[png, jpg, gif]
            stylesheets/
                *.[styl, css]
            javascripts/
                *.[coffee, js]
                .../
        views/
            *.jade
        app.[coffee, js]
        routes.[coffee, js]
    dist/
        {{compiled}}
or

static/
    src/
        .../
        img/
            *.[png, jpg, gif]
        css/
            *.[css, less]
        js/
            *.[coffee, js]
        *.html
    dist/
        {{compiled}}

=end

args = ARGV
dir  = File.expand_path File.dirname __FILE__

class Bootstrap
    attr_reader :dir
    
    def initialize args, dir
        @dir = dir
        conf = filter_args args
        puts conf.map {|arr| parse_conf arr, @dir}
    end
    
    def filter_args args
        args.map {|arg| arg.scan(/(.+)=(.*)/).flatten}
    end
    
    def parse_conf arr, dir
        key, value = arr
        case key
        when "path"
            # Redo using value split on /, testing indexes
            if value.include? ".."
                value.scan("..").map do |v|
                    path  = dir.split("/")
                    path  = path.take(path.size-1)
                    dir   = path.join("/")
                end
                value = value.split("../").flatten.reject(&:empty?)[0]
            end
            @dir = "#{dir}/#{value}"
        else
            puts "[#{key}]:[#{value}] is not valid"
        end
    end
end

launch = Bootstrap.new args, dir