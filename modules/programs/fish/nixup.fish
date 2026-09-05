function nixup -d "Rebuild NixOS"
    switch (count $argv)
        case 0
            nh os switch -d always -H $hostname

        case 1
            switch $argv[1]
                case delta
                    set -l repo "$HOME/.repositories/delta"

                    if not test -d "$repo"
                        echo "nixup: delta repository not found: $repo" >&2
                        return 1
                    end

                    "$repo/nix/builder.sh" --sync delta
                    or return $status

                    sudo systemd-run --collect --pipe --wait \
                        nh os switch -d always -H $hostname
                case '*'
                    echo "nixup: unknown target '$argv[1]'" >&2
                    echo "usage: nixup [delta]" >&2
                    return 2
            end

        case '*'
            echo "usage: nixup [delta]" >&2
            return 2
    end
end
