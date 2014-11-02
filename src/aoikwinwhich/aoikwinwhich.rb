#/
def find_executable(prog)
    #/ 8f1kRCu
    env_var_PATHEXT = ENV['PATHEXT']
    ## can be nil

    #/ 6qhHTHF
    #/ split into a list of extensions
    ext_s = if env_var_PATHEXT.nil?
    then []
    else env_var_PATHEXT.split(File::PATH_SEPARATOR)
    end

    #/ 2pGJrMW
    #/ strip
    ext_s = ext_s.map{|x| x.strip}

    #/ 2gqeHHl
    #/ remove empty
    ext_s = ext_s.select{|x| not x.empty?}

    #/ 2zdGM8W
    #/ convert to lowercase
    ext_s = ext_s.map{|x| x.downcase}

    #/ 2fT8aRB
    #/ uniquify
    ext_s.uniq!

    #/ 4ysaQVN
    env_var_PATH = ENV['PATH']
    ## can be nil

    #/ 6mPI0lg
    dir_path_s = if env_var_PATH.nil?
    then []
    else env_var_PATH.split(File::PATH_SEPARATOR)
    end

    #/ 5rT49zI
    #/ insert empty dir path to the beginning
    ##
    ## Empty dir handles the case that |prog| is a path, either relative or absolute.
    ## See code 7rO7NIN.
    if not dir_path_s.include? ''
        dir_path_s.unshift ''
    end

    #/ 2klTv20
    #/ uniquify
    dir_path_s.uniq!

    #/ 6bFwhbv
    exe_path_s = []

    dir_path_s.each do |dir_path|
        #/ 7rO7NIN
        #/ synthesize a path with the dir and prog
        if dir_path.empty?
            path = prog
        else
            path = File.join(dir_path, prog)
        end

        #/ 6kZa5cq
        ## assume the path has extension, check if it is an executable
        if path.end_with?(*ext_s) and File.file? path
            exe_path_s.push(path)
        end

        #/ 2sJhhEV
        ## assume the path has no extension
        ext_s.each do |ext|
            #/ 6k9X6GP
            #/ synthesize a new path with the path and the executable extension
            path_plus_ext = path + ext

            #/ 6kabzQg
            #/ check if it is an executable
            if File.file? path_plus_ext
                exe_path_s.push(path_plus_ext)
            end
        end
    end

    #/ 8swW6Av
    #/ uniquify
    exe_path_s.uniq!

    #/
    exe_path_s.map!{|x| x.sub('/', "\\")}

    #/
    return exe_path_s
end

def main
    #/ 9mlJlKg
    if ARGV.length != 1
        #/ 7rOUXFo
        #/ print program usage
        puts('Usage: aoikwinwhich PROG')
        puts('')
        puts('#/ PROG can be either name or path')
        puts('aoikwinwhich notepad.exe')
        puts('aoikwinwhich C:\Windows\notepad.exe')
        puts('')
        puts('#/ PROG can be either absolute or relative')
        puts('aoikwinwhich C:\Windows\notepad.exe')
        puts('aoikwinwhich Windows\notepad.exe')
        puts('')
        puts('#/ PROG can be either with or without extension')
        puts('aoikwinwhich notepad.exe')
        puts('aoikwinwhich notepad')
        puts('aoikwinwhich C:\Windows\notepad.exe')
        puts('aoikwinwhich C:\Windows\notepad')

        return
    end

    #/ 9m5B08H
    #/ get name or path of a program from cmd arg
    prog = ARGV[0]

    #/ 8ulvPXM
    #/ find executables
    path_s = find_executable(prog)

    #/ 5fWrcaF
    #/ has found none, exit
    if path_s.empty?
        #/ 3uswpx0
        return
    end

    #/ 9xPCWuS
    #/ has found some, output
    txt = path_s.join("\n")

    puts txt

    #/ 4s1yY1b
    return
end

if __FILE__ == $0
    main()
end
