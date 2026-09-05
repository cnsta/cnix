function flakeup -d "Update Nix flake inputs"
    switch (count $argv)
        case 0
            nix flake update

        case 1
            switch $argv[1]
                case delta
                    nix flake update --flake "$NH_FLAKE" river-delta

                case '*'
                    echo "flakeup: unknown input '$argv[1]'" >&2
                    echo "usage: flakeup [delta]" >&2
                    return 2
            end

        case '*'
            echo "usage: flakeup [delta]" >&2
            return 2
    end
end
