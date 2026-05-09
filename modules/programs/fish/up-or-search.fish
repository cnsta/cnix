function up-or-search
    if commandline --search-mode
        commandline -f history-search-backward
        return
    end
    if commandline --paging-mode
        commandline -f up-line
        return
    end
    set -l lineno (commandline -L)
    switch $lineno
        case 1
            commandline -f history-search-backward
            history merge
        case '*'
            commandline -f up-line
    end
end
